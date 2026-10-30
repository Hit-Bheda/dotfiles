-- Environment variables
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("TZ", "Asia/Kolkata")

-- Qt apps: use qt6ct when it is installed, so the palette/Kvantum theme from
-- `theme-apply` is honoured. Without it Qt falls back to the GTK/portal theme
-- (which theme-apply also keeps dark).
local function exists(path)
	local ok = os.execute("test -e '" .. path .. "' 2>/dev/null")
	return ok == 0 or ok == true
end

if exists("/usr/lib/qt6/plugins/platformthemes/libqt6ct.so") then
	hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
end
