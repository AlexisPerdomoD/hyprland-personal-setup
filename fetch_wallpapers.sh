#!/usr/bin/bash
# Fetch fresh 2K/4K wallpapers from Wallhaven into the Wallpapers folder.
# One theme at a time (random by default, or via --theme), falling back to other
# themes when one is exhausted. Games/brands/movies are excluded via blacklist.
# Usage: fetch_wallpapers.sh [-n COUNT] [-r MIN_RES] [-t TOP_RANGE]
#                            [--theme NAME | -q QUERY] [--blacklist LIST]
#                            [--clean | --no-clean | --clean-all] [--dry-run]

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Documents/Wallpapers/}"
COUNT=10
MIN_RES="2560x1440"
TOPRANGE="1M"
DRY_RUN=0
CLEAN_MODE="" # wallhaven (default) | all | none
CLEAN_REQUESTED=0
API="https://wallhaven.cc/api/v1/search"

# Themes (wallhaven search keywords). Picked one at a time, random by default.
# "anime" and "solid" are supported (add yours to this list to include it).
THEMES=(
    "nature"
    "space"
    "zen"
    "minimalism"
    "abstract"
    "solid"
    "anime"
    "landscape"
    "mountain"
    "stars"
)

# Keywords excluded server-side via the q param ("-kw ...").
BLACKLIST="game movie film tv series character logo brand superhero car sports weapons war motorbike"
BLACKLIST_SERVER=$(printf '%s' "$BLACKLIST" | sed 's/ /%20-/g; s/^/-/')

# AI-generated wallpapers are excluded by default, unless --allow-ai is given.
AI_BLACKLIST="ai ai-art ai-generated midjourney stable-diffusion dalle stable-diffusion-2 novelai"
AI_SERVER=$(printf '%s' "$AI_BLACKLIST" | sed 's/ /%20-/g; s/^/-/')
ALLOW_AI=0

usage() {
    echo "Usage: $0 [-n COUNT] [-r MIN_RES] [-t TOP_RANGE]"
    echo "              [--theme NAME | -q QUERY] [--blacklist LIST]"
    echo "              [--allow-ai] [--clean | --no-clean | --clean-all] [--dry-run]"
    echo "  -n COUNT       Number of wallpapers to fetch (default: 10)"
    echo "  -r MIN_RES     Minimum native resolution, WxH (default: 2560x1440)"
    echo "  -t TOP_RANGE   Wallhaven toplist range: 1d 3d 1w 1M 3M 6M 1y (default: 1M)"
    echo "  --theme NAME   Single theme (default: random theme per fetch)"
    echo "  --list-themes  Print available themes and exit"
    echo "  -q QUERY       Custom search query, overrides themes entirely"
    echo "  --blacklist L  Space-separated keywords to exclude (default builtin)"
    echo "  --allow-ai     Include AI-generated wallpapers (excluded by default)"
    echo "  --clean        Delete files already in $WALLPAPER_DIR (default)"
    echo "  --no-clean     Keep everything already in $WALLPAPER_DIR"
    echo "  --clean-all    Delete all files in $WALLPAPER_DIR (not just wallhaven-*)"
    echo "  --dry-run      Show what would be deleted/downloaded without doing it"
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
    -n)
        COUNT="$2"
        shift 2
        ;;
    -r)
        MIN_RES="$2"
        shift 2
        ;;
    -t)
        TOPRANGE="$2"
        shift 2
        ;;
    --theme)
        THEME="$2"
        shift 2
        ;;
    --list-themes)
        echo "Available themes:"
        printf '  %s\n' "${THEMES[@]}"
        exit 0
        ;;
    -q)
        QUERY_LIST=("$2")
        shift 2
        ;;
    --blacklist)
        BLACKLIST="$2"
        BLACKLIST_SERVER=$(printf '%s' "$BLACKLIST" | sed 's/ /%20-/g; s/^/-/')
        shift 2
        ;;
    --allow-ai)
        ALLOW_AI=1
        shift
        ;;
    --clean)
        CLEAN_MODE="wallhaven"
        CLEAN_REQUESTED=1
        shift
        ;;
    --no-clean)
        CLEAN_MODE="none"
        CLEAN_REQUESTED=1
        shift
        ;;
    --clean-all)
        CLEAN_MODE="all"
        CLEAN_REQUESTED=1
        shift
        ;;
    --dry-run)
        DRY_RUN=1
        shift
        ;;
    -h | --help) usage ;;
    *)
        echo "Unknown option: $1" >&2
        usage
        ;;
    esac
done

if [[ -z "$CLEAN_MODE" ]]; then
    CLEAN_MODE="wallhaven"
fi

[[ "$COUNT" =~ ^[1-9][0-9]*$ ]] || {
    echo "Invalid count: $COUNT (must be a positive integer)" >&2
    exit 1
}
[[ "$MIN_RES" =~ ^[0-9]+x[0-9]+$ ]] || {
    echo "Invalid resolution: $MIN_RES (use WxH, e.g. 2560x1440)" >&2
    exit 1
}

MIN_W="${MIN_RES%x*}"
MIN_H="${MIN_RES#*x}"

case "$TOPRANGE" in
1d | 3d | 1w | 1M | 3M | 6M | 1y) ;;
*)
    echo "Invalid top range: $TOPRANGE (use 1d 3d 1w 1M 3M 6M 1y)" >&2
    exit 1
    ;;
esac

if [[ -n "${THEME:-}" ]]; then
    theme_valid=0
    for t in "${THEMES[@]}"; do
        [[ "$THEME" == "$t" ]] && theme_valid=1
    done
    [[ "$theme_valid" -eq 1 ]] || {
        echo "Unknown theme: $THEME (run --list-themes)" >&2
        exit 1
    }
    if [[ -z "${QUERY_LIST:-}" ]]; then
        QUERY_LIST=("$THEME")
    fi
elif [[ -z "${QUERY_LIST:-}" ]]; then
    readarray -t PERM < <(seq 0 "$(( ${#THEMES[@]} - 1 ))" | shuf)
    TMP_LIST=()
    for idx in "${PERM[@]}"; do
        TMP_LIST+=("${THEMES[$idx]}")
    done
    QUERY_LIST=("${TMP_LIST[@]}")
fi

cleanup_candidates() {
    case "$CLEAN_MODE" in
    none) : ;;
    all) find "$WALLPAPER_DIR" -maxdepth 1 -type f ;;
    wallhaven) find "$WALLPAPER_DIR" -maxdepth 1 -type f -name "wallhaven-*" ;;
    esac
}

mkdir -p "$WALLPAPER_DIR"

already_on_disk() {
    local id="$1"
    find "$WALLPAPER_DIR" -maxdepth 1 -type f -name "wallhaven-$id.*" -print -quit |
        grep -q .
}

download_list="$(mktemp)"
trap 'rm -f "$download_list"' EXIT

found=0
n_themes="${#QUERY_LIST[@]}"
declare -A pages exhausted
for ((i = 0; i < n_themes; i++)); do
    pages[$i]=1
    exhausted[$i]=0
done
theme_idx=0
exhausted_since=0
active_themes=$n_themes

fetch_page() {
    local qstr="${QUERY_LIST[$theme_idx]}"
    local ai_x="${AI_SERVER}"
    [[ "$ALLOW_AI" -eq 1 ]] && ai_x=""
    local qurl="${qstr// /%20}${BLACKLIST_SERVER}${ai_x}"
    local page_no="$1" retries=0
    while [[ $retries -lt 3 ]]; do
        response=$(curl -sf --max-time 20 \
            "$API?q=${qurl}&atleast=$MIN_RES&categories=100&purity=100&sorting=toplist&topRange=$TOPRANGE&ratios=16x9&page=$page_no") &&
            return 0
        retries=$((retries + 1))
        sleep 1
    done
    return 1
}

while [[ "$found" -lt "$COUNT" && "$active_themes" -gt 0 ]]; do
    q=$theme_idx
    page="${pages[$q]}"
    fetch_page "$page" || break

    last_page=$(jq -r '.meta.last_page' <<<"$response")
    [[ "$last_page" =~ ^[0-9]+$ ]] || last_page=0

    if [[ "$last_page" -lt 1 ]]; then
        # Nothing at all matches this theme's filter: skip it.
        if [[ "${exhausted[$q]}" -eq 0 ]]; then
            exhausted[$q]=1
            exhausted_since=$((exhausted_since + 1))
        fi
    else
        took=0
        while IFS=$'\t' read -r id path; do
            [[ "$found" -ge "$COUNT" ]] && break
            already_on_disk "$id" && continue
            grep -q "$id" "$download_list" && continue
            printf '%s\t%s\n' "$path" "$WALLPAPER_DIR/wallhaven-$id.${path##*.}" >>"$download_list"
            found=$((found + 1))
            took=$((took + 1))
        done < <(
            jq -r --argjson min_w "$MIN_W" --argjson min_h "$MIN_H" \
                '.data[] | select(.dimension_x >= $min_w and .dimension_y >= $min_h)
                 | select(.category == "general" or .category == "anime")
                 | [.id, .path] | @tsv' <<<"$response"
        )

        page=$((page + 1))
        if [[ "$page" -gt "$last_page" ]]; then
            page=1
            if [[ "${exhausted[$q]}" -eq 0 && "$took" -eq 0 ]]; then
                # Whole theme consumed without yielding anything new.
                exhausted[$q]=1
                exhausted_since=$((exhausted_since + 1))
            fi
        fi
        pages[$q]="$page"
    fi

    theme_idx=$(( (theme_idx + 1) % n_themes ))
    [[ "$exhausted_since" -ge "$n_themes" ]] && active_themes=0
    sleep 0.2
done

total=$(wc -l <"$download_list")

if [[ "$DRY_RUN" -eq 1 ]]; then
    cleanup_list_file="$(mktemp)"
    trap 'rm -f "$download_list" "$cleanup_list_file"' EXIT
    cleanup_candidates >"$cleanup_list_file" || true
    cleanup_count=$(wc -l <"$cleanup_list_file")

    if [[ "$cleanup_count" -gt 0 ]]; then
        echo "Clean mode: $CLEAN_MODE — would delete $cleanup_count file(s) in $WALLPAPER_DIR:"
        while IFS= read -r f; do
            echo "  ${f##*/}"
        done <"$cleanup_list_file"
    else
        echo "Clean mode: $CLEAN_MODE — nothing to delete in $WALLPAPER_DIR"
    fi

    echo "$total new wallpapers would be downloaded into $WALLPAPER_DIR:"
    while IFS=$'\t' read -r _ out; do
        echo "  ${out##*/}"
    done <"$download_list"
    exit 0
fi

if [[ "$total" -eq 0 ]]; then
    echo "Nothing to download, all top wallpapers already present."
    if [[ "$CLEAN_MODE" != "none" && "$CLEAN_REQUESTED" -eq 0 ]]; then
        echo "Skipping automatic cleanup to avoid emptying $WALLPAPER_DIR (use --clean to force)."
    fi
    notify-send "Wallpapers" "No new wallpapers found" 2>/dev/null || true
    exit 0
fi

deleted=0
if [[ "$CLEAN_MODE" != "none" ]]; then
    backup_list="$(mktemp)"
    cleanup_candidates >"$backup_list" || true
    if [[ -s "$backup_list" ]]; then
        echo "Removing existing wallpapers from $WALLPAPER_DIR ($CLEAN_MODE mode)..."
        while IFS= read -r f; do
            rm -f -- "$f"
            deleted=$((deleted + 1))
        done <"$backup_list"
        echo "Deleted $deleted file(s)."
    fi
    rm -f "$backup_list"
fi

echo "Downloading $total wallpapers into $WALLPAPER_DIR..."
while IFS=$'\t' read -r path out; do
    curl -sfL --max-time 60 -o "$out" "$path" &
done <"$download_list"
wait

failed=0
while IFS=$'\t' read -r _ out; do
    [[ ! -s "$out" ]] && failed=$((failed + 1))
done <"$download_list"

notify-send "Wallpapers fetched" "$((total - failed)) new wallpapers in $WALLPAPER_DIR" 2>/dev/null || true

if [[ "$failed" -gt 0 ]]; then
    echo "Done: $((total - failed))/$total downloaded ($failed failed)"
    exit 1
fi
echo "Done: $total new wallpapers in $WALLPAPER_DIR"
