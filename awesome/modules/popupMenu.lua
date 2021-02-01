-- Custom popup menu library

-- it begins

local boxmargin = 3                           


function createMenu(geo,actions)

    clickPopup = awful.popup {
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

    clickPopup.actions = actions
    
end

local function displayPopup(self,actions)
    if not mousegrabber.isrunning() then
        for _, action in ipairs(actions) do
             local menu_option = wibox.widget {
                     {
                         {
                             text   = action.text,
                             forced_height = 17,
                             widget = wibox.widget.textbox,
                         },
                         margins = 4,
                         widget = wibox.container.margin
                     },
                     shape        = gears.shape.rounded_rect,
                     widget = wibox.container.background
             }
            
            menu_option.clickFunction = action.clickFunction
        end
    end
end
    --Define the popup
    tags = c.screen.tags

    -- Hide the hover tooltip
    tooltip:hide()

    -- Show the menu only if we can grab the mouse
    if not mousegrabber.isrunning() then
        widgetCount = 0
        childWidgets = {} 
        self.clickPopup.ontop = true
        
        --Insert all of the menu options 
        for _, t in ipairs(tags) do
            for _, c2 in ipairs(t:clients()) do
                if t.selected or c2.sticky then
                    if c2.class == c.class then
                        
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
                end
            end
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
