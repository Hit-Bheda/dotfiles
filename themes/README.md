# Themes

One desktop theme = one folder with a `theme.conf` palette. `theme-apply`
renders that palette into every app that needs it, so Hyprland borders, rofi,
waybar, SwayNC, kitty, tmux, Neovim, GTK/GNOME, KDE/KF6 (Dolphin) and Qt all
change together.

```
themes/
├── midnight/                 ← the default dark theme
│   └── theme.conf            ← palette (the only file a theme needs)
├── catppuccin-mocha/         ← pastel dark theme
│   └── theme.conf
├── monochrome/               ← neutral greyscale theme
│   └── theme.conf
├── monochrome-light/         ← its light counterpart
│   └── theme.conf
└── templates/                ← rendered by theme-apply
    ├── hypr-colors.lua       → ~/.config/hypr/colors.lua
    ├── rofi-colors.rasi      → ~/.config/rofi/themes/colors.rasi
    ├── rofi-icons.rasi       → ~/.config/rofi/themes/icons.rasi
    ├── waybar-colors.css     → ~/.config/waybar/colors.css
    ├── swaync-colors.css     → ~/.config/swaync/colors.css
    ├── kitty-colors.conf     → ~/.config/kitty/colors.conf
    ├── tmux-colors.conf      → ~/.config/tmux/colors.conf
    ├── nvim-colors.lua       → ~/.config/nvim/lua/desktop-theme.lua
    ├── gtk.css               → ~/.config/gtk-{3.0,4.0}/gtk.css
    ├── kdeglobals            → ~/.config/kdeglobals
    │                           ~/.local/share/color-schemes/<Name>.colors
    ├── qt6ct.conf            → ~/.config/qt6ct/qt6ct.conf        (if installed)
    └── kvantum.kvconfig      → ~/.config/Kvantum/kvantum.kvconfig (if installed)
```

## Apply

```bash
theme-apply midnight      # or SUPER + Alt + T and pick from rofi
theme-apply --list
theme-apply --current
```

`theme-apply` also rewrites `gtk-*/settings.ini` (theme + icons + font), updates
`gsettings` (so libadwaita, GNOME apps, Flatpak and the XDG portal follow), sets
the cursor, reloads Hyprland, and refreshes waybar, SwayNC, kitty and tmux.
Neovim picks the new palette up after `:colorscheme onedark` or a restart.

Since the scripts write into this repo (the config dirs are stow symlinks), the
applied theme is visible in `git status` — commit it if you want your clone to
reproduce your current look. `~/.config/kdeglobals` is generated but intentionally
not tracked.

## Add a theme

```bash
cp -r ~/dotfiles/themes/midnight ~/dotfiles/themes/nord
$EDITOR ~/dotfiles/themes/nord/theme.conf     # change the palette + name
theme-apply nord
```

That is all — the new theme shows up in `theme-picker` immediately.

### Optional per-theme overrides

Anything in `themes/<name>/` that has the same name as a template replaces that
template for this theme only. For example `themes/nord/gtk.css` to give Nord a
different GTK CSS, or `themes/nord/rofi-colors.rasi` to add extra rofi variables.

### Keys

| Key | Meaning |
|---|---|
| `name` | display name, also the KDE colour-scheme filename |
| `dark` | `1` = advertise dark mode to GTK/portal (`prefer-dark`) |
| `gtk_theme`, `icon_theme`, `cursor_theme`, `cursor_size`, `font` | GTK/GNOME settings; `icon_theme` also drives rofi and KDE |
| `kvantum_theme` | Kvantum theme name (used when Kvantum is installed) |
| `bg`, `bg_alt`, `surface`, `overlay`, `border` | backgrounds and lines |
| `fg`, `fg_dim`, `muted` | text colours |
| `accent`, `accent2`, `accent_fg` | highlight colour, gradient partner, text on accent |
| `red`, `orange`, `green`, `blue` | status colours |
| `wallpaper` | *(optional)* absolute image path applied with hyprpaper |

Every `#rrggbb` value also gets `_rgb` (`51,204,255`), `_bare` (`33ccff`) and
`_hypr` (`rgba(33ccffee)`) variants available to templates.

### Icons

`icon_theme` is set per theme, so each palette uses the Tela variant that
matches it. The [Tela icon theme](https://github.com/vinceliuice/Tela-icon-theme)
is installed user-locally by `./install.sh`; to install it by hand:

```bash
git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme && ./install.sh purple dracula grey standard
```

That creates `Tela-<color>`, `Tela-<color>-light` and `Tela-<color>-dark`
under `~/.local/share/icons`. Use the `-dark` variant on dark palettes and
`-light` on light ones. Current mapping:

| Theme | `icon_theme` | Why |
|---|---|---|
| Catppuccin Mocha | `Tela-dracula-dark` | Tela's Dracula accent `#bd93f9` is almost Catppuccin mauve `#cba6f7`; folder body `#44475a` matches `overlay` |
| Midnight | `Tela-dark` | standard blue folders, light icons for the dark bar |
| Monochrome | `Tela-grey-dark` | neutral grey folders |
| Monochrome Light | `Tela-grey-light` | grey folders with dark panel icons |

List installed icon themes with:

```bash
find /usr/share/icons ~/.local/share/icons ~/.icons \
    -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort -u
```

Then set it in `themes/<name>/theme.conf` and re-apply:

```ini
icon_theme = Tela-purple-dark
```

`theme-apply` writes the choice to GTK 3/4 (`settings.ini`), `gsettings`, rofi
(`themes/icons.rasi`), SwayNC and KDE/KF6 (`kdeglobals`). Waybar uses Nerd Font
glyphs, not an icon theme. Restart SwayNC after changing `icon_theme` so it
reloads app icons:

```bash
pkill -x swaync; sleep 0.3; setsid -f swaync
```

## Kvantum / qt6ct (optional)

KDE apps (Dolphin, etc.) are themed through `kdeglobals` alone — nothing else is
needed. For a fully custom Qt/Kvantum look:

```bash
sudo pacman -S kvantum qt6ct
```

Then set `kvantum_theme = <name>` in `theme.conf` (check `kvantummanager` for
installed themes, e.g. `KvArcDark` or `Kvantum`) and run `theme-apply` again.
It writes `~/.config/Kvantum/kvantum.kvconfig` and `~/.config/qt6ct/qt6ct.conf`,
and `hypr/environment.lua` exports `QT_QPA_PLATFORMTHEME=qt6ct` automatically
once qt6ct is present (log out/in or restart Qt apps afterwards).
