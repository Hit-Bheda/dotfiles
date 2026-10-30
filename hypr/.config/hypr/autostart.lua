-- Autostart programs and daemons
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	-- hyprpaper reads ~/.config/hypr/hyprpaper.conf (kept up to date by
	-- ~/.local/bin/wallpaper-picker) and restores the last chosen wallpaper.
	hl.exec_cmd("hyprpaper")

	-- Generate wallpaper previews in the background so the picker opens
	-- instantly (only missing previews are built).
	hl.exec_cmd("sleep 10; nice -n 19 " .. os.getenv("HOME") .. "/.local/bin/wallpaper-picker --warm-cache")

	hl.exec_cmd("swaync")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("easyeffects --gapplication-service")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
