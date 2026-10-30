#!/usr/bin/env bash

# ============================================================
# Arch Linux Cleanup
#
# Automated cleanup of:
#   - Pacman package cache
#   - Orphan packages
#   - Systemd journal logs
#   - User application cache
#   - Temporary files (using systemd-tmpfiles policy)
#   - Unused Flatpak runtimes (if installed)
#
# Usage:
#   chmod +x arch-cleanup.sh
#   ./arch-cleanup.sh
#
# Optional:
#   ./arch-cleanup.sh --dry-run
#
# Requirements:
#   - Arch Linux
#   - sudo privileges
# ============================================================

set -Eeuo pipefail

# -----------------------------
# Configuration
# -----------------------------

KEEP_PACMAN_VERSIONS=3
KEEP_JOURNAL_DAYS=7
KEEP_TEMP_FILES_DAYS=7

DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# -----------------------------
# Helpers
# -----------------------------

log() {
    printf '\n\033[1;34m==> %s\033[0m\n' "$1"
}

info() {
    printf '    %s\n' "$1"
}

warn() {
    printf '\033[1;33m[WARNING]\033[0m %s\n' "$1"
}

run() {
    if $DRY_RUN; then
        printf '[DRY-RUN] '
        printf '%q ' "$@"
        printf '\n'
    else
        "$@"
    fi
}

# Require execution as a regular user.
if [[ "$EUID" -eq 0 ]]; then
    echo "Run this script as your regular user, not root."
    exit 1
fi

# Obtain sudo credentials before starting.
sudo -v

# -----------------------------
# Initial disk report
# -----------------------------

log "Disk usage BEFORE cleanup"

df -h /

# -----------------------------
# 1. Pacman cache
# -----------------------------

log "Cleaning Pacman cache"

if command -v paccache >/dev/null 2>&1; then
    info "Keeping the last ${KEEP_PACMAN_VERSIONS} versions."

    run sudo paccache -rk "$KEEP_PACMAN_VERSIONS"
else
    warn "paccache is unavailable."
    info "Falling back to pacman -Sc."
    info "This keeps installed packages but removes other cached packages."

    run sudo pacman -Sc --noconfirm
fi

# -----------------------------
# 2. Orphan packages
# -----------------------------

log "Removing orphan packages"

mapfile -t ORPHANS < <(pacman -Qtdq 2>/dev/null || true)

if ((${#ORPHANS[@]})); then
    info "Found ${#ORPHANS[@]} orphan packages."

    run sudo pacman -Rns --noconfirm -- "${ORPHANS[@]}"
else
    info "No orphan packages found."
fi

# -----------------------------
# 3. Systemd journal
# -----------------------------

log "Cleaning systemd journal"

info "Keeping logs from the last ${KEEP_JOURNAL_DAYS} days."

run sudo journalctl \
    --vacuum-time="${KEEP_JOURNAL_DAYS}d"

# -----------------------------
# 4. User cache
# -----------------------------

log "Cleaning user application cache"

USER_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}"

if [[ -d "$USER_CACHE" ]]; then
    info "Cache directory: $USER_CACHE"
    info "Removing cached application data."

    if $DRY_RUN; then
        find "$USER_CACHE" -mindepth 1 -maxdepth 1 -print
    else
        find "$USER_CACHE" \
            -mindepth 1 \
            -maxdepth 1 \
            -exec rm -rf -- {} +
    fi
else
    info "No user cache directory found."
fi

# -----------------------------
# 5. Temporary files
# -----------------------------

log "Cleaning temporary files"

info "Applying systemd-tmpfiles cleanup policy."

run sudo systemd-tmpfiles --clean

# -----------------------------
# 6. Flatpak
# -----------------------------

log "Cleaning unused Flatpak runtimes"

if command -v flatpak >/dev/null 2>&1; then
    run flatpak uninstall --unused --assumeyes
else
    info "Flatpak is not installed. Skipping."
fi

# -----------------------------
# Final disk report
# -----------------------------

log "Disk usage AFTER cleanup"

df -h /

log "Cleanup completed"
