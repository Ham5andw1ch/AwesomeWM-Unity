---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()
local theme = {}
theme.systray_icon_spacing = 4

theme.font          = "Roboto Condensed 8.5"

theme.bg_normal     = "#272822"
theme.bg_focus      = "#414338"
theme.bg_urgent     = "#f92672"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.titlebar_bg_normal = "#414338"
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = "#414338"
theme.titlebar_fg_focus = theme.fg_normal

theme.fg_normal     = "#fffffb"
theme.fg_focus      = "#fffffb"
theme.fg_urgent     = "#fffffb"
theme.fg_minimize   = "#fffffb"

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#272822"
theme.border_focus  = "#f8f8f2"
theme.border_marked = "#91231c"

--theme.tasklist_bg_minimize     = theme.bg_normal
--theme.tasklist_bg_focus      = "#414338"
--theme.tasklist_bg_urgent     = "#f92672"
--theme.tasklist_bg_normal   = theme.bg_normal

theme.tasklist_bg_minimize     = "#00000000"
theme.tasklist_bg_focus      = "#414338"
theme.tasklist_bg_urgent     = "#f92672"
theme.tasklist_bg_normal   = "#00000000"

theme.tasklist_fg_minimize   = "#fffffb"
theme.tasklist_fg_focus      = "#fffffb"
theme.tasklist_fg_urgent     = "#fffffb"
theme.tasklist_fg_normal     = "#fffffb"
theme.underline_color        =  "#f92672"
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
theme.icon_theme = 'Papirus-Dark'
-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.tray_icon = config_path.."2x/tray.png"
theme.tray_icon_close = config_path.."2x/tray_close.png"

-- Define the image to load
theme.titlebar_close_button_normal = config_path.."2x/close_mac.png"
theme.titlebar_close_button_focus  = config_path.."2x/close_mac.png"
theme.titlebar_close_button_focus_hover  = config_path.."2x/close_hover_mac.png"

theme.titlebar_minimize_button_normal = config_path.."2x/window_mac.png"
theme.titlebar_minimize_button_focus_hover = config_path.."2x/window_hover_mac.png"
theme.titlebar_minimize_button_focus  = config_path.."2x/window_mac.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = config_path.."2x/maximize_mac.png"
theme.titlebar_maximized_button_focus_inactive  = config_path.."2x/maximize_mac.png"
theme.titlebar_maximized_button_focus_inactive_hover  = config_path.."2x/maximize_hover_mac.png"
theme.titlebar_maximized_button_normal_active =   config_path.."2x/maximize_mac.png"
theme.titlebar_maximized_button_focus_active  =   config_path.."2x/maximize_mac.png"
theme.titlebar_maximized_button_focus_active_hover  =   config_path.."2x/restore_hover_mac.png"

theme.wallpaper = themes_path.."default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.notification_icon_size = 100
return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
