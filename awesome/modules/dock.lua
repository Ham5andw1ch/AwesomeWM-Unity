-- Adds a Unity Style dock to the screen.

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local properFullscreen = require("modules/properFullscreen")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local function get_screen(s)
    return s and screen[s]
end


local mymenu = awful.menu()

taskWidgets = {}


-- Pseudo deprecated. Needs to be moved to The Monolithic Callback tm
local tasklist_buttons =
    gears.table.join(
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

function getAllClients(c)
    clients = {}
    local tags = c.screen.tags
    -- for each tag
    for _, t in ipairs(tags) do
        if t.selected then
            for _, c2 in ipairs(t:clients()) do
                if c2.class == c.class then
                    table.insert(clients,c2)
                end
            end
        else
            for _, c2 in ipairs(t:clients()) do
                if c2.sticky then
                    if c2.class == c.class then
                        table.insert(clients,c2)
                    end
                end
            end
        end
    end
    return clients
end

-- Filter function that only renders one of each window. 
-- The window counter is handled in the update callback
function filterCombine(c,screen)
    if screen ~= c.screen then return false end
    local tags = c.screen.tags
    for _, t in ipairs(tags) do
        if t.selected then
            for _, c2 in ipairs(t:clients()) do
                if c2.class == c.class then
                    if c2 == c then
                        return true
                    else
                        return false
                    end
                end
            end
        else
            for _, c2 in ipairs(t:clients()) do
                if c2.sticky then
                    if c2.class == c.class then
                        if c2 == c then
                            return true
                        else
                            return false
                        end
                    end
                end
            end
        end
    end
end

-- Add a dock to each screen
awful.screen.connect_for_each_screen(
    function(s)

        s.mylauncher = wibox.widget {
            awful.widget.launcher({ image = gears.filesystem.get_configuration_dir() .. "/2x/apps.png", top = 4,
            command = "rofi -modi drun -show drun -theme slingshot -yoffset 34 -xoffset 54" }),
            left = 6,
            top = 6,
            bottom = 6,
            right = 6,
            widget = wibox.container.margin,
        }
        
        -- Box that holds the screen layout
        s.mylayoutbox = wibox.widget {
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

        --TODO move this to the theme.lua
        s.dockWidth = 50
        s.dockMargin = 8
        s.iconMargin = 4
        
        s.dockbar =
            awful.wibar({
                type = "dock",
                ontop = true,
                screen = s,
                width = s.dockWidth,
                position = "left",
                bg = beautiful.dock_back
            }
        )

        --Define the dock
        s.mydock =
            awful.widget.tasklist {
            screen = s,
            filter = filterCombine,
            buttons = tasklist_buttons,
            style = {
                shape_border_width = 5,
                shape_border_color = "#777777"
            },
            layout = {
                spacing = 0,
                max_widget_size = s.dockWidth + s.dockMargin,
                layout = wibox.layout.flex.vertical
            },
            -- Notice that there is *NO* wibox.wibox prefix, it is a template,
            -- not a widget instance.
            widget_template = {
                {
                    {
                        {
                            id = "ticks",
                            layout=wibox.layout.flex.vertical
                        },
                        {
                           { 
                                {
                                    resize = true,
                                    id = "icon_role",
                                    widget = wibox.widget.imagebox
                                },
                                align = "center",
                                widget = wibox.container.place
                            },
                            margins = s.iconMargin,
                            align = "center",
                            widget = wibox.container.margin
                               
                        },
                        layout = wibox.layout.align.horizontal
                    },
                    id = "back_color",
                    widget = wibox.container.background,

                },
                lol = "nice",
                bottom = s.dockMargin,
                id = 'element',
                widget = wibox.container.margin,

                    create_callback = function(self, c, index, objects)
                        if awful.screen.focused() == c.screen then
                            if client.focus.class == c.class then
                                self:get_children_by_id('back_color')[1].bg = beautiful.bg_focus
                            else
                                self:get_children_by_id('back_color')[1].bg = ""
                            end
                        else
                            self:get_children_by_id('back_color')[1].bg = ""
                        end
                        -- Get the number of clients that match the class
                        totalTicks = 0
                        local tags = c.screen.tags
                        -- for each tag
                        currentClients = getAllClients(c)
                        for _, c1 in ipairs(currentClients) do
                            totalTicks = totalTicks + 1
                        end
                        allTicks = {}
                        theWidget = wibox.widget
                            {   
                                {
                                    max_value = 1,
                                    value = 1,
                                    border_width = 1,
                                    color = beautiful.underline_color,
                                    forced_width = 3,
                                    widget = wibox.widget.progressbar,
                                    shape = gears.shape.rounded_rect
                                },
                                left = 2,
                                top = 2,
                                bottom = 2,
                                widget = wibox.container.margin
                            }
                    
                        for i = 1,totalTicks,1 do
                            table.insert(allTicks, theWidget)
                        end
                        self:get_children_by_id('ticks')[1]:set_children(allTicks)

                        local tooltip = awful.tooltip({
                                objects = { self },
                                timer_function = function()
                                      return "  " .. c.class .. " "
                                end,
                         })
                        if taskWidgets[c.screen.index] == nil then
                            taskWidgets[c.screen.index] = {}
                        end
                
                        taskWidgets[c.screen.index][c.class] = self
                        tooltip.shape = function(cr, w, h)
                            gears.shape.rectangular_tag(cr, w, h,8)
                        end
                        tooltip.mode = "outside"
                        tooltip.timeout = 1/144.0
                          -- Then you can set tooltip props if required
                          -- tooltip.align = "right"
                          -- tooltip.mode = "outside"
                        tooltip.preferred_positions = {"right"}
                        tooltip.preferred_alignments = {"middle"}
                        

                        self:connect_signal("button::release",function(_,_,_,_,_,geo)
                            local boxmargin = 3                           
                            --Define the popup
                            tags = c.screen.tags

                            self.clickPopup = awful.popup {
                                widget = {
                                    {
                                        id = "list",
                                        layout = wibox.layout.flex.vertical
                                    },
                                    margins = boxmargin,
                                    widget = wibox.container.margin
                                },
                                border_width = 5,
                                placement    = false,
                                preferred_positions = {"right"},
                                preferred_anchors   = {"middle","front"},
                                shape        = gears.shape.rounded_rect,
                                visible=true
                            }
                            -- Hide the hover tooltip
                            tooltip:hide()
            
                            -- Show the menu only if we can grab the mouse
                            if not mousegrabber.isrunning() then
                                widgetCount = 0
                                childWidgets = {} 
                                self.clickPopup.ontop = true
                                
                                --Insert all of the menu options 
                                local clients = getAllClients(c)
                                for _, c2 in ipairs(clients) do
                                    local textName = ""
                                    if (c2.name == nil or c2.name == "") then
                                        textName = "<Unnamed>"
                                    else
                                        textName = c2.name
                                    end
                                    -- Widget to be inserted
                                    local test_widget = wibox.widget {
                                            {
                                                {
                                                    text   = textName,
                                                    forced_height = 17,
                                                    widget = wibox.widget.textbox,
                                                },
                                                margins = 4,
                                                widget = wibox.container.margin
                                            },
                                            shape        = gears.shape.rounded_rect,
                                            widget = wibox.container.background
                                    }
                                    -- TODO make this either programmatically calculated or an option. Most likely an option.
                                    self.clickPopup.height = self.clickPopup.height + 17 + 8
                                    --ID to identify them as well as a click function
                                    test_widget.id =  "menuOpt" 
                                    test_widget.client = c2
                                    test_widget.ontop = c2.ontop
                                    test_widget.minimized = c2.minimized
                                    test_widget.border_color = c2.border_color
                                    test_widget.clickFun = function()
                                        if c2==client.focus then 
                                            c2.minimized = true 
                                        else 
                                            c2:emit_signal("request::activate","tasklist",{raise=true})
                                        end 
                                        self.clickPopup.visible = false
                                    end,
                                    table.insert(childWidgets, test_widget)
                                end
                                self.clickPopup.widget:get_children_by_id('list')[1]:set_children(childWidgets)
                                local _,position = awful.placement.next_to(self.clickPopup, {
                                    geometry            = geo,
                                    honor_workarea      = true,
                                    preferred_positions = {"right"},
                                    preferred_anchors   = {"middle","front"},
                                    pretend             = false
                                })

                                self.clickPopup.current_position = postition
                                self.clickPopup.visible = true

                                local buttonDown = false;
                                local x = -1
                                local y = -1
                                -- Hand implement menu clicks here
                                --THIS FUNCTION SUCKS. IT FREAKING SUCKS. REFACTOR PLEASE.
                                local timeout = false
                                local timer = gears.timer({timeout = 0.016, autostart = false, single_shot = true, callback = function() timeout = true end})
                                timer:start()
                                
                                -- 
                                if client.focus ~= nil then
                                    client.focus.border_color = beautiful.bg_normal
                                end
                                
                                mousegrabber.run(function(a)
                                    if timeout or a.buttons[1] or buttonDown then
                                        timeout = false
                                        timer:start()
                                        local hit = false
                                        if a.buttons[1] then
                                            buttonDown = true;
                                        end
                                        if #self.clickPopup.widget:get_children_by_id('list') > 0 then
                                            for _,newWidget in pairs(self.clickPopup.widget:get_children_by_id('list')[1].children) do
                                                if newWidget.id ~= nil then
                                                    if newWidget.id == "menuOpt" then
                                                        newWidget.bg = beautiful.bg_normal
                                                        newWidget.client.ontop = newWidget.ontop
                                                    end
                                                end
                                            end
                                        end
                                        safeClick = false
                                        
                                        currents = mouse.current_widgets
                                        if currents ~= nil then
                                            for _,current in pairs(currents) do
                                                if current ~= nil then
                                                    if current == self then
                                                        if not a.buttons[1] and buttonDown then
                                                            safeClick = true
                                                            buttonDown = false
                                                        end
                                                    elseif current == self.clickPopup.widget then
                                                        if not a.buttons[1] and buttonDown then
                                                            safeClick = true
                                                        end
                                                    elseif current.id ~= nil then
                                                        if current.id == "menuOpt" then
                                                            --On hover, set
                                                            if #self.clickPopup.widget:get_children_by_id('list') > 0 then
                                                                for _,newWidget in pairs(self.clickPopup.widget:get_children_by_id('list')[1].children) do
                                                                    if newWidget.id ~= nil then
                                                                        if newWidget.id == "menuOpt" then
                                                                            if newWidget ~= current then
                                                                                newWidget.bg = beautiful.bg_normal
                                                                                newWidget.client.ontop = newWidget.ontop
                                                                                newWidget.client.minimized = newWidget.minimized
                                                                                newWidget.client.border_color =  beautiful.border_normal
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            hit = true
                                                            current.bg = beautiful.bg_focus
                                                            current.client.ontop = true
                                                            current.client.minimized = false
                                                            current.client.border_color = "#FFFFFF"
                                                            
                                                            --On Click, reset
                                                            if not a.buttons[1] and buttonDown then
                                                                if #self.clickPopup.widget:get_children_by_id('list') > 0 then
                                                                    for _,newWidget in pairs(self.clickPopup.widget:get_children_by_id('list')[1].children) do
                                                                        if newWidget.id ~= nil then
                                                                            if newWidget.id == "menuOpt" then
                                                                                newWidget.client.minimized = newWidget.minimized
                                                                                newWidget.client.ontop = newWidget.ontop
                                                                                newWidget.client.border_color =  newWidget.border_color
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                                current:clickFun()
                                                                self.clickPopup.visible = false


                                                                return false
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if not hit then
                                                if #self.clickPopup.widget:get_children_by_id('list') > 0 then
                                                    for _,newWidget in pairs(self.clickPopup.widget:get_children_by_id('list')[1].children) do
                                                        if newWidget.id ~= nil then
                                                            if newWidget.id == "menuOpt" then
                                                                newWidget.client.minimized = newWidget.minimized
                                                                newWidget.bg = beautiful.bg_normal
                                                                newWidget.client.ontop = newWidget.ontop
                                                                newWidget.client.border_color =  beautiful.border_normal
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            --if current.get_children_by_id ~= nil then
                                            --    awful.spawn("notify-send yuh")
                                            --    if #current:get_children_by_id('list') ~= 0 then
                                            --        current:get_children_by_id('list')[1]:get_children_by_id('menuOpt')[1].bg = beautiful.bg_focus
                                            --        awful.spawn("notify-send aha2")
                                            --    end
                                            --    awful.spawn("notify-send aha")
                                            --end

                                        end
                                        if not a.buttons[1] and buttonDown and not safeClick then
                                            for _,newWidget in pairs(self.clickPopup.widget:get_children_by_id('list')[1].children) do
                                                if newWidget.id ~= nil then
                                                    if newWidget.id == "menuOpt" then
                                                        newWidget.client.minimized = newWidget.minimized
                                                        newWidget.client.ontop = newWidget.ontop
                                                        newWidget.client.border_color =  newWidget.border_color
                                                    end
                                                end
                                            end
                                            self.clickPopup.visible = false
                                            return false
                                        else
                                            if safeClick then
                                                buttonDown = false
                                            end
                                            return true
                                        end
                                    else
                                        return true
                                    end
                                end,"arrow")
                            end
                        end)
                    end,

                    update_callback = function(self,c,index,objects)
                        if awful.screen.focused() == c.screen then
                            if client.focus ~= nil then
                                if client.focus.class == c.class then
                                    self:get_children_by_id('back_color')[1].bg = beautiful.bg_focus
                                else
                                    self:get_children_by_id('back_color')[1].bg = ""
                                end
                            else
                                self:get_children_by_id('back_color')[1].bg = ""
                            end

                        else
                            self:get_children_by_id('back_color')[1].bg = ""
                        end
                        -- Get the number of clients that match the class
                        totalTicks = 0
                        local tags = c.screen.tags
                        -- for each tag
                        for _, t in ipairs(tags) do
                            if t.selected then
                                for _, c2 in ipairs(t:clients()) do
                                    if c2.class == c.class then
                                        totalTicks = totalTicks + 1
                                    end
                                end
                            else
                                for _, c2 in ipairs(t:clients()) do
                                    if c2.sticky then
                                        if c2.class == c.class then
                                            totalTicks = totalTicks + 1
                                        end
                                    end
                                end
                            end
                        end
                        allTicks = {}
                        theWidget = wibox.widget
                            {   
                                {
                                    max_value = 1,
                                    value = 1,
                                    border_width = 1,
                                    color = beautiful.underline_color,
                                    forced_width = 3,
                                    widget = wibox.widget.progressbar,
                                    shape = gears.shape.rounded_rect
                                },
                                left = 2,
                                top = 2,
                                bottom = 2,
                                widget = wibox.container.margin
                            }
                    
                        for i = 1,totalTicks,1 do
                            table.insert(allTicks, theWidget)
                        end
                        self:get_children_by_id('ticks')[1]:set_children(allTicks)
                        if taskWidgets[c.screen.index] == nil then
                            taskWidgets[c.screen.index] = {}
                        end
                        taskWidgets[c.screen.index][c.class] = self
                        if taskWidgets[c.screen.index][c.class] == nil then
                            taskWidgets[c.screen.index] = {}
                        end

                    end
            },
        }

        --Set the parentbar
        
        --Add a properfullscreen handler to hide the bar as needed.
        properFullscreen.newHandler(s.dockbar)
        
        --Finally, setup the bar
        s.dockbar:setup {
            layout = wibox.layout.align.vertical,
            {
                layout = wibox.layout.fixed.vertical,
                s.mylauncher
                
            },
            s.mydock,
            {
                layout = wibox.layout.fixed.vertical,
                s.mylayoutbox
            }
        }
    end
)






