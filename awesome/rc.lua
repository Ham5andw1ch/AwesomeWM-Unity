-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.

pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- require("awful.dbus")
 require("awful.remote")
-- local dbus = dbus
-- dbus.request_name("org.awesomewm.test","session")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)

--MODULES
require("modules/dock")
require("modules/keybinds")
require("modules/icons")
require("modules/rules")
local properFullscreen = require("modules/properFullscreen")


if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "st"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"



mytext =
    wibox.widget {
    markup = " No status command. Call \"update_status('text')\" through awesome-client. ",
    valign = "center",
    widget = wibox.widget.textbox
}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    awful.layout.suit.max.fullscreen
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- Create a launcher widget and a main menu
awful.spawn.easy_async("/home/donov/.awesomerc")
myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {
        "manual",
        terminal .. " -e man awesome"
    },
    {
        "edit config",
        editor_cmd .. " " .. awesome.conffile
    },
    {
        "restart",
        awesome.restart
    },
    {
        "quit",
        function()
            awesome.quit()
        end
    }
}
mymainmenu =
    awful.menu(
    {
        items = {
            {
                "awesome",
                myawesomemenu,
                beautiful.awesome_icon
            },
            {
                "open terminal",
                terminal
            }
        }
    }
)

mylauncher =
    wibox.widget {
    awful.widget.launcher(
        {
            image = "~/.config/awesome/2x/arch.png",
            top = 4,
            command = "AdvancedRofi.sh"
        }
    ),
    left = 2,
    top = 2,
    bottom = 2,
    right = 2,
    widget = wibox.container.margin
}
myNotif =
    wibox.widget {
    awful.widget.launcher(
        {
            image = "~/.config/awesome/2x/menu.png",
            top = 4,
            command = "ShowNotifications.sh"
        }
    ),
    left = 2,
    top = 2,
    bottom = 2,
    right = 2,
    widget = wibox.container.margin
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {
            modkey
        },
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {
            modkey
        },
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    )
)

local tasklist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
            --    c.minimized = true
            else
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    {
                        raise = true
                    }
                )
            end
        end
    ),
    awful.button(
        {},
        3,
        function(c)
            c:kill()
        end
    ),
    awful.button(
        {},
        4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

local function set_wallpaper(s)
    -- Wallpaper
    -- if beautiful.wallpaper then
    --    local wallpaper = beautiful.wallpaper
    --    -- If wallpaper is a function, call it with the screen
    --    if type(wallpaper) == "function" then
    --        wallpaper = wallpaper(s)
    --    end
    --    gears.wallpaper.maximized(wallpaper, s, true)
    -- end
    awful.spawn("~/.fehbg")
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(
    function(s)
        -- Each screen has its own tag table.
        awful.tag(
            {
                " 1 ",
                " 2 ",
                " 3 ",
                " 4 ",
                " 5 ",
                " 6 ",
                "7"
            },
            s,
            awful.layout.layouts[1]
        )

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox =
            wibox.widget {
            awful.widget.layoutbox(s),
            left = 8,
            top = 8,
            bottom = 8,
            right = 8,
            widget = wibox.container.margin
        }
        s.mylayoutbox:buttons(
            gears.table.join(
                awful.button(
                    {},
                    1,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.layout.inc(-1)
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.layout.inc(-1)
                    end
                )
            )
        )
        -- Create a taglist widget
        function noscratch(t)
            if t.name == "7" then
                return false
            else
                return true
            end
        end
        s.mytaglist =
            awful.widget.taglist {
            screen = s,
            filter = noscratch,
            -- layout = {
            --        spacing = 5,
            --        layout = wibox.layout.fixed.horizontal
            --    },
            buttons = taglist_buttons
            -- widget_template = {
            --    {
            --        forced_width = 15,
            --        id     = 'text_role',
            --        widget = wibox.widget.textbox,
            --    },
            --    layout = wibox.layout.fixed.horizontal,
            -- }
        }

        -- Create a tasklist widget
        s.mytasklist =
            awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            style = {
                shape_border_width = 0,
                shape_border_color = "#777777"
            },
            filter = awful.widget.tasklist.filter.focused,
            layout = {
                spacing = 0,
 --               max_widget_size = 150,
                layout = wibox.layout.flex.horizontal
            },
            -- Notice that there is *NO* wibox.wibox prefix, it is a template,
            -- not a widget instance.
            widget_template = {
                {
                    -- {
                        {
                            {
                                --{
                                --    {
                                --        id = "icon_role",
                                --        widget = wibox.widget.imagebox
                                --    },
                                --    left = 4,
                                --    right = 4,
                                --    top = 4,
                                --    bottom = 4,
                                --    widget = wibox.container.margin
                                --},
                                {
                                    id = "text_role",
                                    widget = wibox.widget.textbox
                                },
                                forced_height = beautiful.bar_height - 2,
                                layout = wibox.layout.fixed.horizontal
                            },
                            right = 2,
                            widget = wibox.container.margin
                        },
                        --{
                        --    max_value = 1,
                        --    value = 1,
                        --    border_width = 0,
                        --    color = beautiful.underline_color,
                        --    forced_height = 1,
                        --    widget = wibox.widget.progressbar
                        --},
                        layout = wibox.layout.align.vertical
                    -- },
                    -- id = "background_role",
                    -- widget = wibox.container.background
                },
                left = 2,
                right = 2,
                widget = wibox.container.margin
            }
        }
    
        s.dockWidth = 50
        s.dockMargin = 8
        s.iconMargin = 4

        s.mySeparate =
            wibox.widget.separator {
            orientation = "horizontal",
            span_ratio = 0
        }

        s.separate =
            wibox.widget {
            buttons = layoutButton,
            markup = " | ",
            align = "right",
            valign = "center",
            widget = wibox.widget.textbox
        }

        
      
        update_status = function(text)
            mytext.text = text
            --awful.spawn("notify-send \"".. text .. "\"")
        end

        s.space =
            wibox.widget {
            markup = " ",
            align = "right",
            valign = "center",
            widget = wibox.widget.textbox
        }
        s.tspace =
            wibox.widget {
            markup = "   ",
            align = "right",
            valign = "center",
            widget = wibox.widget.textbox
        }
        bar_margin = (beautiful.bar_height - 18)/2
        s.my_systray =
            wibox.widget {
            wibox.widget.systray(),
            left = 5,
            top = bar_margin,
            bottom = bar_margin,
            right = 5,
            widget = wibox.container.margin
        }
        s.my_layoutbox =
            wibox.widget {
            wibox.widget.systray(),
            left = 2,
            top = 2,
            bottom = 2,
            right = 2,
            widget = wibox.container.margin
        }

        local cbuttons =
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    local screen1 = awful.screen.focused()

                    screen1.closing = true
                    local num = #screen1.clients
                    for i, item in pairs(screen1.clients) do
                        if item.class == "Xfdesktop" or item.class == "Komorebi" then
                            num = num - 1
                        end
                    end
                    if num > 0 then
                        for k, c in pairs(screen1.clients) do
                            if c.class ~= "Xfdesktop" then
                                c.minimized = true
                            end
                        end
                    else
                        -- awful.spawn("notify-send ".. #screen1.client_memory)
                        if #screen1.client_memory ~= 0 then
                            for k, c in pairs(screen1.client_memory) do
                                c.minimized = false
                            end
                        end
                    end
                    screen1.closing = false
                end
            )
        )
        layoutText = function(layout)
            if layout.name == "tile" then
                return(" []= ")
            end
            if layout.name == "floating" then
                return(" ><> ")
            end
            if layout.name == "fullscreen" then
                return(" [M] ")
            end
            -- if layout =
        end
        local layoutButton = 
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    awful.layout.inc(1)
                    local screen1 = awful.screen.focused()
                    s.layoutWidget.text = layoutText(s.selected_tag.layout)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.layout.inc(-1)
                end
            )
        )
        s.layoutWidget =
            wibox.widget {
            buttons = layoutButton,
            text = layoutText(s.selected_tag.layout),
            align = "right",
            font = "hack 8",
            valign = "center",
            widget = wibox.widget.textbox
        }
        s.my_button =
            wibox.widget {
            max_value = 1,
            value = 0,
            opacity = 0,
            border_width = 0,
            color = beautiful.bg_focus,
            widget = wibox.widget.progressbar
        }
        s.my_space =
            wibox.widget {
            max_value = 1,
            value = 0,
            opacity = 0,
            width = s.dockWidth,
            color = beautiful.bg_normal,
            widget = wibox.widget.progressbar
        }

        s.my_bar =
            wibox.widget {
            {
                s.my_button,
                buttons = cbuttons,
                forced_width = 7,
                layout = wibox.layout.fixed.horizontal
            },
            left = 1,
            right = 1,
            color = beautiful.bg_focus,
            widget = wibox.container.margin
        }

        s.my_button:connect_signal(
            "mouse::enter",
            function(b)
                b.value = 1
                b.opacity = 1
            end
        )

        s.my_button:connect_signal(
            "mouse::leave",
            function(b)
                b.value = 0
                b.opacity = 0
            end
        )
        --                         s.tray = false
        s.my_systray.visible = true

        local tbuttons =
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    s.tray = not s.tray
                    if (s.tray) then
                        s.testImage.image = beautiful.tray_icon_close
                        s.my_systray.visible = true
                    else
                        s.testImage.image = beautiful.tray_icon
                        s.my_systray.visible = false
                    end
                end
            )
        )

        s.testImage =
            wibox.widget {
            image = beautiful.tray_icon_close,
            left = 2,
            top = 2,
            bottom = 2,
            right = 2,
            buttons = tbuttons,
            widget = wibox.widget.imagebox
        }


        if (s.index == 1) then
            s.myWidget = s.testImage
        else
            s.myWidget = s.space
        end
        -- Add widgets to the wibox
        s.mywibox =
            awful.wibar(
            {
                type = "dock",
                ontop = true,
                screen = s,
                height = beautiful.bar_height,
                position = "top"
            }
        )
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
               -- s.my_space,
                s.space,
                s.mytaglist,
                s.space,
                s.mypromptbox
            },
            s.mytasklist,
            {
                layout = wibox.layout.fixed.horizontal,
                mytext,
                s.space,
                --s.layoutWidget,
                --s.space,
                s.my_systray,
                s.space,
                s.my_bar
            }
        }
        properFullscreen.newHandler(s.mywibox)
        s.tray = not s.tray
        if (s.tray) then
            s.testImage.image = beautiful.tray_icon_close
            s.my_systray.visible = true
        else
            s.testImage.image = beautiful.tray_icon
            s.my_systray.visible = false
        end
    end
)




-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.

        if not awesome.startup then
            -- awful.client.setslave(c)
            if #c.screen.clients > 1 then
                --                naughty.notify({title = c.screen.clients[2].class})
                awful.client.swap.byidx(1, c.screen.clients[1], true)
            end
        end
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.

client.connect_signal(
    "request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons =
            gears.table.join(
            awful.button(
                {},
                1,
                function()
                    c:emit_signal(
                        "request::activate",
                        "titlebar",
                        {
                            raise = true
                        }
                    )
                    if c.maximized then
                        oldWidth = c.width
                        oldHeight = c.height
                        c.maximized = false
                        c.x = c.screen.geometry.x
                        c.y = c.screen.geometry.y
                        c.width = oldWidth
                        c.height = oldHeight
                    end
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:emit_signal(
                        "request::activate",
                        "titlebar",
                        {
                            raise = true
                        }
                    )
                    if c.maximized then
                        oldWidth = c.width
                        oldHeight = c.height
                        c.maximized = false
                        c.x = c.screen.geometry.x
                        c.y = c.screen.geometry.y
                        c.width = oldWidth
                        c.height = oldHeight
                    end
                    awful.mouse.resize(c,context)
                end
            )
        )
        c.space =
            wibox.widget {
            markup = "  ",
            align = "right",
            valign = "center",
            widget = wibox.widget.textbox
        }

        awful.titlebar(
            c,
            {
                size = 22
            }
        ):setup {
            {
                    {
                        awful.titlebar.widget.closebutton(c),
                        margins = 0,
                        widget = wibox.container.margin
                    },
                    {
                        awful.titlebar.widget.minimizebutton(c),
                        margins = 0,
                        widget = wibox.container.margin
                    },
                    {
                        awful.titlebar.widget.maximizedbutton(c),
                        margins = 0,
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.horizontal
            },
            {
                {
                    -- Title
                    align = "left",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                -- Middle
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                {
                    buttons = buttons,
                    layout = wibox.layout.flex.horizontal
                },
                {
                    buttons = buttons,
                    layout = wibox.layout.flex.horizontal
                },
                {
                {
                    awful.titlebar.widget.iconwidget(c),
                    buttons = buttons,
                    layout = wibox.layout.fixed.horizontal
                },
                -- Left
                margins = 1,
                widget = wibox.container.margin
                },   
                layout = wibox.layout.align.horizontal
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal(
            "request::activate",
            "mouse_enter",
            {
                raise = false
            }
        )
    end
)
bannedList = {
    "plank",
    "dockx",
    "komorebi",
    "xfdesktop",
    "komorebi",
    "xfce4-panel",
    "wrapper-2.0"
}

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)
-- }}}
-- Hide bars when app go fullscreen
local b = true




function isException(title)
    -- awful.spawn("notify-send " .. title)
    for i, item in pairs(bannedList) do
        if item == title then
            return true
        end
    end
    return false
end


client.connect_signal(
    "property::floating",
    function(c)
        local b = false
        if c.first_tag ~= nil then
            b = c.first_tag.layout.name == "floating"
        end
        if not (isException(c.instance) or (c.type == "dialog")) then
            test = isException(c.instance)
            -- awful.spawn("notify-send " .. string.format("%s",test))
            if c.floating or b then
               -- awful.titlebar.show(c)
            else
                awful.titlebar.hide(c)
            end
        else
            awful.titlebar.hide(c)
        end
    end
)
screen.connect_signal(
    "property::geometry",
    function(s)
        awful.spawn("~/.fehbg")
    end
)

tag.connect_signal(
    "property::layout",
    function(t)
        local clients = t:clients()
        for k, c in pairs(clients) do
            if not (isException(c.instance) or (c.type == "dialog")) then
                test = isException(c.instance)

                -- awful.spawn("notify-send " .. c.instance)
                if c.floating or c.first_tag.layout.name == "floating" then
                    awful.titlebar.show(c)
                else
                    awful.titlebar.hide(c)
                end
            else
                awful.titlebar.hide(c)
            end
        end
    end
)
tag.connect_signal(
    "tagged",
    function(t)
        local clients = t:clients()
        for k, c in pairs(clients) do
            if not (isException(c.instance) or (c.type == "dialog")) then
                test = isException(c.instance)
                -- awful.spawn("notify-send " .. string.format("%s",test))
                if c.floating or c.first_tag.layout.name == "floating" then
                    awful.titlebar.show(c)
                else
                    awful.titlebar.hide(c)
                end
            else
                awful.titlebar.hide(c)
            end
        end
    end
)
screen.connect_signal(
    "tag::history::update",
    function(s)
        local clients = s.selected_tag:clients()
        for k, c in pairs(clients) do
            if not (isException(c.instance) or (not c.type == "dialog")) then
                test = isException(c.instance)
                -- awful.spawn("notify-send " .. string.format("%s",test))
                if c.floating or c.first_tag.layout.name == "floating" then
                   awful.titlebar.show(c)
                else
                    awful.titlebar.hide(c)
                end
            else
                awful.titlebar.hide(c)
            end
        end
    end
)

--
-- Show Desktop Code
--
function table.shallow_copy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end
function table.shallow_copy_except(t, d)
    local t2 = {}
    for k, v in pairs(t) do
        if v.name ~= d.name then
            t2[k] = v
        else
            -- awful.spawn("notify-send hi")
        end
    end
    return t2
end

tag.connect_signal(
    "property::layout",
    function(t)
        s = t.screen
        s.layoutWidget.text = layoutText(s.selected_tag.layout)
    end
)   

screen.connect_signal(
    "tag::history::update",
    function(s)
        s.layoutWidget.text = layoutText(s.selected_tag.layout)
        if s.closing ~= true then
            if s.clients ~= nil then
                if s.lul == nil then
                    s.lul = false
                end
                s.lul = not s.lul
                local tags = s.clients
                local num = #s.clients
                for k, d in pairs(tags) do
                    if d.class == "Xfdesktop" then
                        num = num - 1
                    end
                end
                s.client_memory = table.shallow_copy(s.clients)
            end
        end
    end
)

function clientStuff(c)
    if awful.screen.focused().closing ~= true then
        local tags = awful.screen.focused().clients
        local num = #awful.screen.focused().clients
        for k, d in pairs(tags) do
            if d.class == "Xfdesktop" then
                num = num - 1
            end
        end
        --                  awful.spawn("notify-send "..num)
        awful.screen.focused().client_memory = table.shallow_copy(c.screen.clients)
    end
end
function clientCloseStuff(c)
    if c.screen.closing ~= true then
        local tags = c.screen.clients
        local num = #c.screen.clients
        for k, d in pairs(tags) do
            if d.class == "Xfdesktop" or d == c then
                num = num - 1
            end
        end
        if num > 0 then
            c.screen.client_memory = table.shallow_copy(c.screen.clients)
            for k, d in pairs(c.screen.client_memory) do
                -- awful.spawn("notify-send " .. d.class)
                if d == c then
                    c.screen.client_memory[k] = nil
                end
            end
        end
    end
end
client.connect_signal(
    "property::minimized",
    function(c)
        clientStuff(c)
    end
)
client.connect_signal(
    "unmanage",
    function(c)
        clientStuff(c)
    end
)
client.connect_signal(
    "manage",
    function(c)
        clientStuff(c)
    end
)

--
-- Icon Code
--

client.connect_signal(
    "manage",
    function(c)
            if not (isException(c.instance) or (c.type == "dialog")) then
                test = isException(c.instance)
                -- awful.spawn("notify-send " .. string.format("%s",test))
                if c.floating or c.first_tag.layout.name == "floating" then
                    awful.titlebar.show(c)
                else
                    awful.titlebar.hide(c)
                end
            else
                awful.titlebar.hide(c)
        
        end
    end
)
client.connect_signal(
    "manage",
    function(c, startup)
        -- Enable round corners with the shape api
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 6)
        end
    end
)
