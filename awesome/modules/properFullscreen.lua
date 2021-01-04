-- Hides Bars when apps enter fullscreen

local awful = require("awful")
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local properFullscreen = {}



function properFullscreen.newHandler(b)
    local handler = {bar=b}
    function handler:updateBarsVisibility()
        if self.bar.screen.selected_tag then
            --            awful.spawn("notify-send " .. s.selected_tag.layout.name)
            self.bar.visible = not self.bar.screen.selected_tag.fullscreenMode
        end
    end
    tag.connect_signal(
        "property::selected",
        function(t)
            if #t.screen.clients == 0 then
                t.fullscreenMode = false
            end
            handler:updateBarsVisibility()
        end
    )
    
    tag.connect_signal(
        "property::layout",
        function(t)
            local full = false
            for k, c in pairs(t:clients()) do
                if (c.focus and c.fullscreen) then
                    full = true
                end
            end
            t.fullscreenMode = t.layout.name == "fullscreen" and full
            handler:updateBarsVisibility()
        end
    )
    
    client.connect_signal(
        "property::minimized",
        function(c)
            if #c.screen.clients == 0 then
                c.first_tag.fullscreenMode = false
            end
            handler:updateBarsVisibility()
        end
    )
    
    client.connect_signal(
        "property::fullscreen",
        function(c)
            if c.first_tag ~= nil then
                if c.type == "normal" then 
                    c.first_tag.fullscreenMode = c.fullscreen or c.screen.selected_tag.layout.name == "fullscreen"
                end
            end
            handler:updateBarsVisibility()
        end
    )
    
    client.connect_signal(
        "focus",
        function(c)
            if c.type == "normal" then 
                c.first_tag.fullscreenMode = c.fullscreen or c.screen.selected_tag.layout.name == "fullscreen"
            end
            handler:updateBarsVisibility()
        end
    )
    
    client.connect_signal(
        "unmanage",
        function(c)
            if c.fullscreen then
                c.screen.selected_tag.fullscreenMode = not c.fullscreen
                handler:updateBarsVisibility()
            end
        end
    )
    return handler;
end



-- Signals 


return properFullscreen
