-- Monitor configuration
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Laptop display (primary)
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1.2,
})

-- External monitor (LG ULTRAGEAR) - right of laptop
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@120",
    position = "1600x0",
    scale    = 1,
})
