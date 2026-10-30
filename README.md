# dotfiles

Hyprland desktop config managed with [GNU stow](https://www.gnu.org/software/stow/).

```
dotfiles/
├── hypr/    →  ~/.config/hypr      Hyprland (Lua config), hyprpaper, hypridle, hyprlock
├── waybar/  →  ~/.config/waybar    bar layout + style
├── rofi/    →  ~/.config/rofi      launcher/clipboard/pickers config + theme
├── gtk/     →  ~/.config/gtk-3.0, gtk-4.0   GTK theme/icons (dark by default)
├── bin/     →  ~/.local/bin        emoji picker, wallpaper picker, power menu, theme picker
└── install.sh
```

Each top-level directory is a stow *package* that mirrors `$HOME`, so the whole
thing is symlinked into place:

```
~/.config/hypr -> ~/dotfiles/hypr/.config/hypr
~/.local/bin/emoji-picker -> ~/dotfiles/bin/.local/bin/emoji-picker
```

Edit files in `~/dotfiles` (or through the symlinks) and they are live.

## Install

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` backs up any real file it would replace to
`~/.dotfiles-backup/<timestamp>/`, then stows every package.

Manual equivalent:

```bash
cd ~/dotfiles
stow -v -t "$HOME" hypr waybar rofi bin
```

## Requirements

| Kind | Packages |
|---|---|
| Compositor | `hyprland` (build with Lua config support), `hyprpaper`, `hypridle`, `hyprlock` |
| UI | `waybar`, `rofi` (Wayland build), `swaync`, `breeze-dark` icon theme, JetBrainsMono Nerd Font |
| Picker helpers | `jq`, `libvips` (`vipsheader`, `vipsthumbnail`), `imagemagick` (fallback), `wl-clipboard`, `cliphist`, `curl` |
| Misc | `brightnessctl`, `playerctl`, `wireplumber`, `gammastep`, `hyprshot`, `kitty`, `dolphin`, `easyeffects` |

## Keybinds (`SUPER` = main modifier)

| Keys | Action |
|---|---|
| `SUPER + Return` | terminal |
| `SUPER + E` | file manager |
| `SUPER + Space` | app launcher (rofi drun) |
| `SUPER + V` | clipboard history (cliphist + rofi) |
| `SUPER + .` | emoji picker (copies to clipboard) |
| `SUPER + Alt + W` | wallpaper picker (hyprpaper) |
| `SUPER + Alt + T` | GTK/Qt theme picker |
| `SUPER + BackSpace` / `SUPER + M` | power menu |
| `SUPER + L` | lock screen |
| `SUPER + S` / `SUPER + Shift + S` | scratchpad (special workspace) |
| `SUPER + N` | night light toggle |
| `SUPER + Shift + W` | restart waybar |
| `SUPER + 1…0`, `SUPER + Shift + 1…0` | focus / move to workspace |
| `SUPER + Shift + P` | screenshot a region |

Media/brightness keys are bound through `XF86*` keysyms in `hypr/keybinds.lua`.

## Scripts (`bin`)

- **`emoji-picker`** — fuzzy emoji list in rofi, copies the pick to `wl-copy`.
  Unicode data is cached in `~/.local/share/emoji/emoji-test.txt`.
- **`wallpaper-picker`** — rofi grid of wallpaper thumbnails, applies with
  `hyprctl hyprpaper` on all monitors and writes `~/.config/hypr/hyprpaper.conf`
  so the choice survives reboots. Previews are cached in
  `~/.cache/rofi-wallpaper-thumbs`; `wallpaper-picker --warm-cache` (run at
  login) generates them in the background. Scans
  `~/Pictures`, `~/Pictures/Wallpapers`, `~/Wallpapers`, `~/.local/share/wallpapers`
  and `~/Downloads`.
- **`power-menu`** — rofi power menu: lock, suspend, logout, reboot, shutdown.
- **`theme-picker`** — rofi list of installed GTK themes. Applies the choice to
  GTK3/GTK4 (`settings.ini`), GNOME/libadwaita (`gsettings`), and sets
  `color-scheme` so Qt/KDE and Flatpak apps follow through the XDG portal.
  `theme-picker <name>` applies directly.
- **`nightlight-toggle`**, **`battery-notify`** — small helpers used by keybind/waybar.

## Lock / idle

- `hypr/hyprlock.conf` — blurred screenshot background, clock, date, user, cyan
  password field.
- `hypr/hypridle.conf` — display off after 2.5 min, lock after 5 min, lock before
  suspend.

## Themes

GTK3/GTK4, libadwaita (GNOME) and Qt/KDE apps are dark by default:

- `gtk/settings.ini` files set `Adwaita-dark` + `breeze-dark` icons.
- `gsettings` sets `color-scheme=prefer-dark`, which the XDG portal exposes to
  libadwaita, Qt ≥ 6.5 (Dolphin, etc.) and Flatpak apps.
- `SUPER + Alt + T` (`theme-picker`) lists installed themes from
  `/usr/share/themes` and `~/.local/share/themes` (plus the built-in Adwaita
  variants) and applies the selection everywhere, switching
  `prefer-dark`/`default` based on the theme name.

Install more themes by dropping them into `~/.local/share/themes/<name>`; they
show up in the picker immediately. `theme-picker Adwaita-dark` also works from a
terminal or script.

## Customize

| What | Where |
|---|---|
| Default apps (terminal, file manager, menu) | `hypr/programs.lua` |
| Gaps, borders, rounding, blur | `hypr/look.lua` |
| Animations | `hypr/animations.lua` |
| Window rules | `hypr/window_rules.lua` |
| Keybinds | `hypr/keybinds.lua` |
| Accent colour (rofi, lock screen) | `rofi/theme.rasi` (`@accent`), `hypr/hyprlock.conf` |
| GTK / Qt theme | `SUPER + Alt + T`, or `theme-picker <name>` |
| Bar layout / colours | `waybar/config.jsonc`, `waybar/style.css` |
| Wallpaper search folders | `SEARCH_DIRS` in `bin/wallpaper-picker` |

### Add another app to the repo

```bash
mkdir -p ~/dotfiles/kitty/.config/kitty
mv ~/.config/kitty/* ~/dotfiles/kitty/.config/kitty/
cd ~/dotfiles && stow -v -t "$HOME" kitty
```

Then add `kitty` to `PACKAGES` in `install.sh` and commit.

### Remove a package from `$HOME` (keep files in the repo)

```bash
cd ~/dotfiles && stow -D -v -t "$HOME" <package>
```

### Notes

- `hypr/hyprpaper.conf` is generated by `wallpaper-picker` (absolute local paths),
  therefore it is git-ignored.
- `hyprpaper` starts without a config on a fresh clone; pick a wallpaper once and
  the file is created.
