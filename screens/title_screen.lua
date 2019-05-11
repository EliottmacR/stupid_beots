
local background_clr = 2
local this -- screen
local sw
local sh

local play_rect = {}

function init_title_screen(z)
  sw = GW
  sh = GH
  this = init_screen("title_screen",update_title_screen, draw_title_screen, background_clr, 0, 0, sw, sh, z or 1)
  play_rect.str = " Play! "  
  play_rect.border = 10 
  
  play_rect = {
    x1 = sw / 2 - str_px_width(play_rect.str)/2 - play_rect.border,
    y1 = sh * 2 / 5 - play_rect.border ,
    x2 = sw / 2 + str_px_width(play_rect.str)/2 - 13 + play_rect.border,
    y2 = sh * 2 / 5 + str_px_height(play_rect.str) * 1.4 + play_rect.border,
    xt = sw / 2,
    yt = sh * 2 / 5,
    border = 10,
    hovered = false
  }
  play_rect.str = "Play!"  
  play_rect.border = 10 
  return this
end

function update_title_screen(dt)

  play_rect.hovered = mouse_in_rect_screen(this, play_rect.x1, play_rect.y1, play_rect.x2, play_rect.y2)
  
  if not (count(transitioning) > 1) then
    if btn(0) and play_rect.hovered then 
      begin_transition_from_to(this,"main_menu")
    end
  end
end

function draw_title_screen()
  cls(background_clr)
  very_cool_print("Stupid Beots !", sw / 2 , 40)
  draw_button(play_rect)  
end









