#!/usr/bin/env bash
# Install these dotfiles with GNU stow.
#
#   ./install.sh              install every package into $HOME
#   TARGET=/somewhere ./install.sh
#
# Any real file that would be replaced is moved to
# ~/.dotfiles-backup/<timestamp>/ first.

set -euo pipefail

REPO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${TARGET:-$HOME}"
PACKAGES=(hypr waybar rofi gtk bin)
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

command -v stow >/dev/null 2>&1 || {
	echo "GNU stow is required (e.g. 'sudo pacman -S stow')."
	exit 1
}

mkdir -p "$TARGET/.config" "$TARGET/.local/bin"

# Move conflicting files out of the way (stow refuses to overwrite them).
# Targets that already resolve into the repo (i.e. already stowed, including
# symlinked parent directories) are left alone.
for pkg in "${PACKAGES[@]}"; do
	while IFS= read -r -d '' file; do
		rel="${file#"$REPO/$pkg/"}"
		dest="$TARGET/$rel"
		[[ -e "$dest" || -L "$dest" ]] || continue
		[[ "$(realpath -m -- "$dest")" == "$REPO/"* ]] && continue

		mkdir -p "$BACKUP/$(dirname "$rel")"
		mv "$dest" "$BACKUP/$rel"
		echo "backed up ~/$rel"
	done < <(find "$REPO/$pkg" -type f -print0)

	# Drop directories that became empty so stow can fold them into symlinks.
	find "$REPO/$pkg" -depth -type d | while IFS= read -r d; do
		rel="${d#"$REPO/$pkg"}"
		rmdir "$TARGET$rel" 2>/dev/null || true
	done
done

for pkg in "${PACKAGES[@]}"; do
	stow -v -t "$TARGET" -d "$REPO" "$pkg"
done

# Folder the wallpaper picker scans.
mkdir -p "$TARGET/Pictures/Wallpapers"

# Dark theme for GTK3/GTK4/libadwaita, and for Qt/Flatpak via the XDG portal.
if command -v gsettings >/dev/null 2>&1; then
	gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
	gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark' 2>/dev/null || true
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
fi

# Render the default theme into every generated colour file
# (hypr, rofi, waybar, GTK, KDE/Qt). Needs the sessions's tools; failures here
# are never fatal.
if [[ -x "$REPO/bin/.local/bin/theme-apply" ]]; then
	"$REPO/bin/.local/bin/theme-apply" "${THEME:-midnight}" || true
fi

echo
echo "Done. Packages stowed into $TARGET: ${PACKAGES[*]}"
[[ -d "$BACKUP" ]] && echo "Old files were backed up to: $BACKUP"
