-- Main Hyprland config
-- Each module handles a specific concern:
--
--   monitors.lua      — display setup
--   programs.lua       — program variables
--   autostart.lua      — startup programs
--   environment.lua    — environment variables
--   look.lua           — gaps, borders, decoration
--   animations.lua     — curves + animation rules
--   layouts.lua        — dwindle / master / scrolling
--   misc.lua           — misc settings
--   input.lua          — keyboard, touchpad, gestures
--   keybinds.lua       — all keybindings
--   window_rules.lua   — window + workspace rules

local modules = {
    "monitors",
    "programs",
    "autostart",
    "environment",
    "look",
    "animations",
    "layouts",
    "misc",
    "input",
    "keybinds",
    "window_rules",
}

for _, mod in ipairs(modules) do
    local ok, err = pcall(require, mod)
    if not ok then
        print("Failed to load config module '" .. mod .. "': " .. tostring(err))
    end
end
