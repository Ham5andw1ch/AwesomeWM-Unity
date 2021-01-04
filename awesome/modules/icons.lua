-- Changes client icons with icons from icon themes

local gears = require("gears")
local menubar = require("menubar")

-- ICON FUNCTION

regexList = {
    "minecraft",
}

function changeIcon(c)
    if c.iconChanged == false then
        c.iconChanged = true
        local name = nil
        c.size_hints_honor = false
        if c.class ~= nil then
            name = c.class
        elseif c.instance ~= nil then
            name = c.instance
        end
        if name ~= nil then
            found = false
            for i,item in pairs(regexList) do
                if string.match(name:lower(),item) then
                    name = item
                    break
                end
            end
            local icon = menubar.utils.lookup_icon(name)
            local lower_icon = menubar.utils.lookup_icon(name:lower())
            if icon ~= nil then
                local new_icon = gears.surface(icon)
                c.icon = new_icon._native
            elseif lower_icon ~= nil then
                local new_icon = gears.surface(lower_icon)
                c.icon = new_icon._native
            elseif c.icon == nil then
                local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
                c.icon = new_icon._native
            end
        else
            local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
            c.icon = new_icon._native
        end
    else
        c.iconChanged = false
    end
end

-- SIGNAL CONNECTION

client.connect_signal(
    "focus",
    function(c)
        changeIcon(c)
    end
)
client.connect_signal(
    "manage",
    function(c)
        c.iconChanged = false
        changeIcon(c)
    end
)
client.connect_signal(
    "property::icon",
    function(c)
        changeIcon(c)
    end
)
