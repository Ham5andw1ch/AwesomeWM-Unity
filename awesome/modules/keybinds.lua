local gears = require("gears")
local awful = require("awful")
modkey = "Mod4"

globalkeys =
    gears.table.join( 
    awful.key(
        {
            modkey
        },
        "Left",
        awful.tag.viewprev,
        {
            description = "view previous",
            group = "tag"
        }
    ),
    awful.key(
        {
            modkey
        },
        "Right",
        awful.tag.viewnext,
        {
            description = "view next",
            group = "tag"
        }
    ),


    awful.key(
        {
            modkey
        },
        "Escape",
        awful.tag.history.restore,
        {
            description = "go back",
            group = "tag"
        }
    ),
    awful.key(
        {
            modkey
        },
        "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {
            description = "focus next by index",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey
        },
        "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {
            description = "focus previous by index",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {
            description = "swap with next client by index",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {
            description = "swap with previous client by index",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Control"
        },
        "j",
        function()
            awful.screen.focus_relative(1)
        end,
        {
            description = "focus the next screen",
            group = "screen"
        }
    ),
    awful.key(
        {
            modkey
        },
        ".",
        function()
            awful.screen.focus_relative(1)
        end,
        {
            description = "focus the next screen",
            group = "screen"
        }
    ),
    awful.key(
        {
            modkey
        },
        ",",
        function()
            awful.screen.focus_relative(-1)
        end,
        {
            description = "focus the previous screen",
            group = "screen"
        }
    ),
    awful.key(
        {
            modkey
        },
        "u",
        awful.client.urgent.jumpto,
        {
            description = "jump to urgent client",
            group = "client"
        }
    ),
    awful.key(
        {
            "Mod1",
        },
        "h",
        function()
            awful.spawn("hud-menu")
        end,
        {
            description = "view all open clients",
            group = "client"
        }
    ),
    awful.key(
        {
            "Mod1"
        },
        "Tab",
        function()
            awful.spawn("rofi -show window -theme material_center.rasi")
        end,
        {
            description = "view all open clients",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey
        },
        "Tab",
        function()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end,
        {
            description = "go back",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "Tab",
        function()
            -- awful.client.focus.history.previous()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus:raise()
            end
        end,
        {
            description = "go forward",
            group = "client"
        }
    ), -- Standard program
    awful.key(
        {
            modkey,
            "Shift"
        },
        "Return",
        function()
            awful.spawn(terminal)
        end,
        {
            description = "open a terminal",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey,
            "Control"
        },
        "r",
        awesome.restart,
        {
            description = "reload awesome",
            group = "awesome"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "q",
        function()
            awful.spawn("powerDMenuTheme.sh")
        end,
        {
            description = "quit awesome",
            group = "awesome"
        }
    ),
    awful.key(
        {},
        "Print",
        function()
            awful.spawn("superMaim 3")
        end,
        {
            description = "open a terminal",
            group = "launcher"
        }
    ),
    awful.key(
        {
            "Shift"
        },
        "Print",
        function()
            awful.spawn("superMaim 4")
        end,
        {
            description = "open a terminal",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey
        },
        "Print",
        function()
            awful.spawn("superMaim 1")
        end,
        {
            description = "open a terminal",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "Print",
        function()
            awful.spawn("superMaim 2")
        end,
        {
            description = "open a terminal",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey
        },
        "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {
            description = "increase master width factor",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey
        },
        "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {
            description = "decrease master width factor",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {
            description = "increase the number of master clients",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {
            description = "decrease the number of master clients",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey
        },
        "i",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {
            description = "increase the number of master clients",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey
        },
        "d",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {
            description = "decrease the number of master clients",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey,
            "Control"
        },
        "h",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {
            description = "increase the number of columns",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey,
            "Control"
        },
        "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {
            description = "decrease the number of columns",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "space",
        function()
            awful.layout.inc(-1)
        end,
        {
            description = "select previous",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey
        },
        "space",
        function()
            awful.layout.inc(1)
        end,
        {
            description = "select previous",
            group = "layout"
        }
    ),
    awful.key(
        {
            modkey,
            "Control"
        },
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate",
                    "key.unminimize",
                    {
                        raise = true
                    }
                )
            end
        end,
        {
            description = "restore minimized",
            group = "client"
        }
    ), -- Prompt
    awful.key(
        {
            modkey
        },
        "r",
        function()
            awful.screen.focused().mypromptbox:run()
        end,
        {
            description = "run prompt",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey
        },
        "x",
        function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {
            description = "lua execute prompt",
            group = "awesome"
        }
    ), -- Menubar
    awful.key(
        {
            "Mod1"
        },
        "space",
        function()
            awful.spawn("rofi -show run -theme material_dmenu")
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "p",
        function()
            awful.spawn("rofi -show drun -icon-theme Papirus-Dark -theme material_dmenu")
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey
        },
        "t",
        function()
            awful.spawn("picom -Fbc -I .1 -O .1 --experimental-backend  --detect-rounded-corners")
            awful.spawn('notify-send "Picom Enabled"')
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "t",
        function()
            awful.spawn("killall picom")
            awful.spawn('notify-send "Picom Disabled"')
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    ),
    awful.key(
        {},
        "XF86AudioRaiseVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
            awful.spawn("play ~/.config/awesome/sound/Pop2.wav")
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    ),
    awful.key(
        {},
        "XF86AudioLowerVolume",
        function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
            awful.spawn("play ~/.config/awesome/sound/Pop2.wav")
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    ),
    awful.key(
        {},
        "XF86AudioMute",
        function()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
            awful.spawn("play ~/.config/awesome/sound/Pop2.wav")
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    )
)

clientkeys =
    gears.table.join(
    awful.key(
        {
            modkey
        },
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {
            description = "toggle fullscreen",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "c",
        function(c)
            c:kill()
        end,
        {
            description = "close",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Control"
        },
        "space",
        awful.client.floating.toggle,
        {
            description = "toggle floating",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey
        },
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {
            description = "move to master",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        ".",
        function(c)
            c:move_to_screen()
        end,
        {
            description = "move to screen",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        ",",
        function(c)
            c:move_to_screen(c.screen.index - 1)
        end,
        {
            description = "move to screen",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey
        },
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {
            description = "minimize",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "s",
        function(c)
            c.sticky = not c.sticky
        end,
        {
            desctipyion = "sticky",
            grouip = "client"
        }   
    ),
    awful.key(
        {
            modkey
        },
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {
            description = "(un)maximize",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Control"
        },
        "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {
            description = "(un)maximize vertically",
            group = "client"
        }
    ),
    awful.key(
        {
            modkey,
            "Shift"
        },
        "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {
            description = "(un)maximize horizontally",
            group = "client"
        }
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys =
        gears.table.join(
        globalkeys, -- View tag only.
        awful.key(
            {
                modkey
            },
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag and tag.name ~= "7" then
                    tag:view_only()
                end
            end,
            {
                description = "view tag #" .. i,
                group = "tag"
            }
        ),
        awful.key(
            {
                modkey,
                "Control"
            },
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag and tag.name ~= "7" then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {
                description = "toggle tag #" .. i,
                group = "tag"
            }
        ),
        awful.key(
            {
                modkey,
                "Shift"
            },
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag and tag.name ~= "7" then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {
                description = "move focused client to tag #" .. i,
                group = "tag"
            }
        ),
        awful.key(
            {
                modkey,
                "Control",
                "Shift"
            },
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag and tag.name ~= "7" then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {
                description = "toggle focused client on tag #" .. i,
                group = "tag"
            }
        )
    )
end

root.keys(globalkeys)
