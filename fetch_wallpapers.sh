#!/usr/bin/bash
# Fetch fresh 2K/4K wallpapers from Wallhaven into the Wallpapers folder.
# Usage: fetch_wallpapers.sh [-n COUNT] [-r MIN_RES] [-t TOP_RANGE] [--dry-run]

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Documents/Wallpapers/}"
COUNT=10
MIN_RES="2560x1440"
TOPRANGE="1M"
DRY_RUN=0
API="https://wallhaven.cc/api/v1/search"

usage() {
    echo "Usage: $0 [-n COUNT] [-r MIN_RES] [-t TOP_RANGE] [--dry-run]"
    echo "  -n COUNT       Number of wallpapers to fetch (default: 10)"
    echo "  -r MIN_RES     Minimum native resolution, WxH (default: 2560x1440)"
    echo "  -t TOP_RANGE   Wallhaven toplist range: 1d 3d 1w 1M 3M 6M 1y (default: 1M)"
    echo "  --dry-run      Show what would be downloaded without fetching"
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

MIN_W="${MIN_RES%x*}"
MIN_H="${MIN_RES#*x}"

case "$TOPRANGE" in
1d | 3d | 1w | 1M | 3M | 6M | 1y) ;;
*)
    echo "Invalid top range: $TOPRANGE (use 1d 3d 1w 1M 3M 6M 1y)" >&2
    exit 1
    ;;
esac

if [[ "$DRY_RUN" -eq 0 ]]; then
    mkdir -p "$WALLPAPER_DIR"
fi

already_on_disk() {
    local id="$1"
    find "$WALLPAPER_DIR" -maxdepth 1 -type f -name "wallhaven-$id.*" -print -quit |
        grep -q .
}

download_list="$(mktemp)"
trap 'rm -f "$download_list"' EXIT

PAGE_CAP=25
found=0

fetch_page() {
    local page_no="$1" retries=0
    while [[ $retries -lt 3 ]]; do
        response=$(curl -sf --max-time 20 \
            "$API?atleast=$MIN_RES&categories=100&purity=100&sorting=toplist&topRange=$TOPRANGE&ratios=16x9&page=$page_no") &&
            return 0
        retries=$((retries + 1))
    done
    return 1
}

fetch_page 1 || {
    echo "API request failed" >&2
    exit 1
}
last_page=$(jq -r '.meta.last_page' <<<"$response")
[[ "$last_page" -gt 0 ]] || {
    echo "No wallpapers found for the current filter" >&2
    exit 1
}

if [[ "$last_page" -lt "$PAGE_CAP" ]]; then
    PAGE_CAP="$last_page"
fi
page=$((RANDOM % PAGE_CAP + 1))
wrapped=0

while [[ "$found" -lt "$COUNT" ]]; do
    fetch_page "$page" || break
    mapfile -t candidates < <(
        jq -c --argjson min_w "$MIN_W" --argjson min_h "$MIN_H" \
            '.data[]
             | select(.dimension_x >= $min_w and .dimension_y >= $min_h)
             | {id, path}' <<<"$response"
    )

    for cand in "${candidates[@]}"; do
        [[ "$found" -ge "$COUNT" ]] && break
        id=$(jq -r '.id' <<<"$cand")
        path=$(jq -r '.path' <<<"$cand")
        [[ -z "$path" ]] && continue
        already_on_disk "$id" && continue
        if grep -q "$id" "$download_list"; then
            continue
        fi
        printf '%s\t%s\n' "$path" "$WALLPAPER_DIR/wallhaven-$id.${path##*.}" >>"$download_list"
        found=$((found + 1))
    done

    page=$((page + 1))
    if [[ "$page" -gt "$last_page" ]]; then
        if [[ "$wrapped" -eq 1 ]]; then
            break
        fi
        page=1
        wrapped=1
    fi
done

total=$(wc -l <"$download_list")

if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "$total new wallpapers would be downloaded into $WALLPAPER_DIR:"
    while IFS=$'\t' read -r _ out; do
        echo "  ${out##*/}"
    done <"$download_list"
    exit 0
fi

if [[ "$total" -eq 0 ]]; then
    echo "Nothing to download, all top wallpapers already present."
    notify-send "Wallpapers" "No new wallpapers found" 2>/dev/null || true
    exit 0
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
