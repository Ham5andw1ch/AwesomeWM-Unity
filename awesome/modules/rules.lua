local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")


clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal(
                "request::activate",
                "mouse_click",
                {
                    raise = true
                }
            )
        end
    ),
    awful.button(
        {
            modkey
        },
        1,
        function(c)
            c:emit_signal(
                "request::activate",
                "mouse_click",
                {
                    raise = true
                }
            )
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {
            modkey
        },
        3,
        function(c)
            c:emit_signal(
                "request::activate",
                "mouse_click",
                {
                    raise = true
                }
            )
            awful.mouse.client.resize(c)
        end
    )
)

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }, -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry"
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {
            floating = true
        }
    }, -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {
                "normal",
                "dialog"
            }
        },
        properties = {
            titlebars_enabled = true
        }
    },
    {
        rule = {
            class = "Xfdesktop"
        },
        properties = {
            sticky = true,
            -- height = screen[1].geometry.height-24,
            size_hints_honor = false,
            y = 0,
            x = 0,
            border_width = 0,
            screen = awful.screen.getbycoord(0, 0),
            tag = "7"
        }
    },
    {
        rule = {
            class = "komorebi"
        },
        properties = {
            sticky = true,
            border_width = 0,
            tag = "7"
        }
    },
    {
        rule_any = {
            name = {
                "Floating for YouTube™",
                "Picture-in-Picture",
            },
        },
        properties = {
            sticky = true
        }
    },
    {
        rule = {
            name = "Picture-in-Picture",
            class = "InputOutput"
        },
        properties = {
            sticky = true
        }
    },
    {
        rule = {
            name = "Picture-in-Picture",
            class = "Firefox"
        },
        properties = {
            sticky = true
        }
    },
    {
        rule = {
            name = "Floating for YouTube™",
            class = "Toolkit"
        },
        properties = {
            sticky = true
        }
    },
    {
        rule = {
            name = "File Operation Progress",
            class = "Thunar"
        },
        properties = {
            ontop = true
        }
    },
    {
        rule = {
            class = "Plank"
        },
        properties = {
            titlebars_enabled = false,
            border_width = 0,
            floating = true,
            sticky = true,
            ontop = true,
            focusable = false,
            below = true
        }
    },
    {
        rule = {
            instance = "xfce-polkit"
        },
        properties = {
            placement = awful.placement.centered,
        }
    }

}
