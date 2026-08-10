----------------
--- Programs ---
----------------
local terminal     = "kitty"
local browser      = "google-chrome-stable"
local fileManager  = "nautilus"
local desktop_menu = "rofi -show drun -show-icons"
local exec_menu    = "rofi -show run"
local window_menu  = "rofi -show window"

------------------------------
--- Configuration settings ---
------------------------------
hl.config({
    binds = {
        movefocus_cycles_groupfirst = true,
    },
})

----------------
--- Keybinds ---
----------------
--- Use super/windows key as main modifier
local mainMod = "SUPER"

--- Start a terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

--- Launch browser
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(browser))

--- Close window
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())

--- Exit Hyprland
hl.bind(
    mainMod .. " + SHIFT + E",
    hl.dsp.exec_cmd(
        "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown" ..
            " || hyprctl dispatch 'hl.dsp.exit()'"
    )
)

--- Start file manager
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))

--- Launcher binds
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(desktop_menu))
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.exec_cmd(exec_menu))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(window_menu))

-- Notifications.
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("makoctl dismiss -a"))
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("makoctl history | rofi -dmenu"))

--- Window orientation toggles
hl.bind(mainMod .. " + W", hl.dsp.group.toggle())  -- Tabbed layout
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- Pseudo-tiling
hl.bind(mainMod .. " + E", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.float({ action = "toggle" }))

--- Focus and window movement within workspace
local movements = {
    { dir = "left",   vim = "H" },
    { dir = "down",   vim = "J" },
    { dir = "up",     vim = "K" },
    { dir = "right",  vim = "L" }
}

for _, map in ipairs(movements) do
    -- Move focus (mainMod + Vim key / Arrow key)
    hl.bind(mainMod .. " + " .. map.vim, hl.dsp.focus({ direction = map.dir }))
    hl.bind(mainMod .. " + " .. map.dir, hl.dsp.focus({ direction = map.dir }))

    -- Move windows (mainMod + SHIFT + Vim key / Arrow key)
    hl.bind(
        mainMod .. " + SHIFT + " .. map.vim,
        hl.dsp.window.move({ direction = map.dir })
    )
    hl.bind(
        mainMod .. " + SHIFT + " .. map.dir,
        hl.dsp.window.move({ direction = map.dir, group_aware = true })
    )
end

--- Workspace switching
-- Switch to previous/next existing strictly numerical workspace.
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e+1" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 and 20 both map to key 0

    if i <= 10 then
        -- Workspaces 1-10
        hl.bind(
            mainMod .. " + " .. key, hl.dsp.focus({ workspace = i })
        )
        hl.bind(
            mainMod .. " + SHIFT + " .. key,
            hl.dsp.window.move({ workspace = i })
        )
    else
        -- Workspaces 11-20
        hl.bind(
            mainMod .. " + CTRL + " .. key, hl.dsp.focus({ workspace = i })
        )
        hl.bind(
            mainMod .. " + CTRL + SHIFT + " .. key,
            hl.dsp.window.move({ workspace = i })
        )
    end
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys for hardware, volume and brightness
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)

local multimedia = {
    {
        key = "XF86AudioRaiseVolume",
        cmd = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ ",
        act = "%+",
    },
    {
        key = "XF86AudioLowerVolume",
        cmd = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ ",
        act = "%-",
    },
    {
        key = "XF86MonBrightnessUp",
        cmd = "brightnessctl -e4 -n2 set ",
        act = "%+",
    },
    {
        key = "XF86MonBrightnessDown",
        cmd = "brightnessctl -e4 -n2 set ",
        act = "%-",
    },
}

for _, map in ipairs(multimedia) do
    -- Standard binding (1% increments)
    hl.bind(map.key, hl.dsp.exec_cmd(map.cmd .. "1" .. map.act),
            { locked = true, repeating = true })

    -- Shift binding (5% increments)
    hl.bind("SHIFT + " .. map.key, hl.dsp.exec_cmd(map.cmd .. "5" .. map.act),
            { locked = true, repeating = true })
end

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


------------
--- TODO ---
------------

--- Special scratchpad workspace (scratchpad)
--- hl.bind(
---     mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic")
--- )
--- hl.bind(
---     mainMod .. " + SHIFT + S",
---     hl.dsp.window.move({ workspace = "special:magic" })
--- )
