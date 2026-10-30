# dotfiles

Hyprland desktop config managed with [GNU stow](https://www.gnu.org/software/stow/).

```
dotfiles/
├── hypr/    →  ~/.config/hypr      Hyprland (Lua config), hyprpaper, hypridle, hyprlock
├── waybar/  →  ~/.config/waybar    bar layout + style
├── rofi/    →  ~/.config/rofi      launcher/clipboard/pickers config + theme
├── gtk/     →  ~/.config/gtk-3.0, gtk-4.0   GTK theme/icons (dark by default)
├── bin/     →  ~/.local/bin        emoji/wallpaper/theme pickers, power menu, helpers
├── themes/  →  (not stowed)        palettes + templates for `theme-apply`
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
`~/.dotfiles-backup/<timestamp>/`, then stows every package and applies the
default `midnight` theme.

Manual equivalent:

```bash
cd ~/dotfiles
stow -v -t "$HOME" hypr waybar rofi gtk bin
theme-apply midnight
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
| `SUPER + Alt + T` | theme picker (desktop themes + GTK) |
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
- **`theme-apply`** — renders a complete theme from `themes/<name>/theme.conf`
  into Hyprland borders, rofi, waybar, GTK, gsettings, KDE and Qt, then reloads
  Hyprland/waybar. `theme-apply --list` / `--current`.
- **`theme-picker`** — rofi picker for the complete themes in `themes/` (and
  plain GTK themes installed system-wide). `theme-picker <name>` applies directly.
- **`nightlight-toggle`**, **`battery-notify`** — small helpers used by keybind/waybar.

## Lock / idle

- `hypr/hyprlock.conf` — blurred screenshot background, clock, date, user, cyan
  password field.
- `hypr/hypridle.conf` — display off after 2.5 min, lock after 5 min, lock before
  suspend.

## Themes

One palette in `themes/<name>/theme.conf` drives the whole desktop. `theme-apply`
(also `SUPER + Alt + T` → `theme-picker`) renders it into:

| Where | File | What changes |
|---|---|---|
| Hyprland | `hypr/colors.lua` | active/inactive border gradient, shadow |
| Hyprlock | `hypr/hyprlock.conf` | `$hl_*` colour block |
| rofi | `rofi/themes/colors.rasi` | background, text, accent, selection |
| waybar | `waybar/colors.css` | every colour used by `style.css` |
| GTK 3/4 | `gtk-*/settings.ini`, `gtk-*/gtk.css` | theme name, icons, font, full palette |
| GNOME/portal | `gsettings` | `gtk-theme`, `icon-theme`, `prefer-dark`, cursor |
| KDE / KF6 | `~/.config/kdeglobals`, `~/.local/share/color-schemes/<Name>.colors` | Dolphin, Ark, Kate, … |
| Qt (optional) | `~/.config/qt6ct/qt6ct.conf`, `~/.config/Kvantum/kvantum.kvconfig` | when qt6ct / Kvantum are installed |

The default theme is **Midnight** — near-black blue-grey background, `#c0caf5`
text and a cyan `#33ccff` accent, with `Adwaita-dark` GTK and `breeze-dark` icons.

```bash
theme-apply --list        # available themes
theme-apply midnight      # apply one
theme-apply --current     # what is applied now
```

### Add a new theme

```bash
cp -r ~/dotfiles/themes/midnight ~/dotfiles/themes/gruvbox
$EDITOR ~/dotfiles/themes/gruvbox/theme.conf   # name + colours
theme-apply gruvbox
```

It appears in `theme-picker` right away. See [`themes/README.md`](themes/README.md)
for every key and for per-theme template overrides.

### Kvantum / qt6ct

KDE apps are dark through `kdeglobals` alone. For a fully custom Qt look install
`kvantum` + `qt6ct` (`sudo pacman -S kvantum qt6ct`), set `kvantum_theme` in the
theme, and re-apply; `hypr/environment.lua` sets `QT_QPA_PLATFORMTHEME=qt6ct`
automatically once qt6ct is present.

## Customize

| What | Where |
|---|---|
| Default apps (terminal, file manager, menu) | `hypr/programs.lua` |
| Gaps, borders, rounding, blur | `hypr/look.lua` |
| Border / shadow colours | `themes/<name>/theme.conf` (`accent`, `accent2`, `border`) |
| Animations | `hypr/animations.lua` |
| Window rules | `hypr/window_rules.lua` |
| Keybinds | `hypr/keybinds.lua` |
| Everything colour-related | `themes/<name>/theme.conf` + `theme-apply` |
| GTK theme / icons / dark mode | `gtk_theme`, `icon_theme`, `dark` in `theme.conf` |
| Bar layout | `waybar/config.jsonc` |
| Rofi layout | `rofi/config.rasi`, `rofi/themes/theme.rasi` |
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
- `~/.config/kdeglobals` is generated by `theme-apply` and lives outside this
  repo on purpose: run `theme-apply <theme>` (or `./install.sh`) after cloning.
- Generated colour files (`hypr/colors.lua`, `rofi/themes/colors.rasi`,
  `waybar/colors.css`, `gtk-*/gtk.css`, `hypr/hyprlock.conf`'s colour block) are
  tracked, so `git status` shows the theme you last applied — commit it if you
  want your clone to reproduce the same look.
