
local background_clr = 2
local this -- screen
local sw
local sh

local play_rect = {}
local shop_rect = {}

local t_display_no_money = 0
local max_t_d_n_m = 3.5

function init_title_screen(z)
  sw = GW
  sh = GH
  this = init_screen("title_screen",update_title_screen, draw_title_screen, background_clr, 0, 0, sw, sh, z or 1)
  ------ Play button
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
  
  ------ Shop button
  shop_rect.str = " W I N "  
  shop_rect.border = 10 
  
  shop_rect = {
    x1 = sw / 2     - str_px_width(shop_rect.str)/2 - shop_rect.border,
    y1 = sh * 3 / 5 - shop_rect.border ,
    x2 = sw / 2     + str_px_width(shop_rect.str)/2 - 13 + shop_rect.border,
    y2 = sh * 3 / 5 + str_px_height(shop_rect.str) * 1.4 + shop_rect.border,
    xt = sw / 2,
    yt = sh * 3 / 5,
    border = 10,
    hovered = false
  }
  shop_rect.str = "W i n"  
  shop_rect.border = 10 
   
  
  display_back = false
  return this
end

function update_title_screen(dt)

  t_display_no_money = t_display_no_money - dt
  
  play_rect.hovered = mouse_in_rect_screen(this, play_rect.x1, play_rect.y1, play_rect.x2, play_rect.y2)
  shop_rect.hovered = mouse_in_rect_screen(this, shop_rect.x1, shop_rect.y1, shop_rect.x2, shop_rect.y2)
  
  if not TRANSIT then 
    if btn(0) and play_rect.hovered then 
      begin_transition_from_to(this,"choose_game")
    end
    if btn(0) and shop_rect.hovered then 
      if my_money < 999 and t_display_no_money < 0 then t_display_no_money = max_t_d_n_m end      
    end
  end
end

function draw_title_screen()
  cls(background_clr)
  very_cool_print("Stupid Beots !", sw / 2 , 40)
  draw_button(play_rect)    
  draw_button(shop_rect)  
  
  shaded_cool_print("Coins:" .. my_money, str_px_width("9"), sh - str_px_height("9")*1.3 + sin_buttons, 0, 5 )
  
  
  if t_display_no_money > 0 then
    local t_transition = max_t_d_n_m/3
    local s_y = -15
    local f_y = sh/4
    local y    
    
    if t_display_no_money > max_t_d_n_m - t_transition then
      y = s_y + easeInOut(max_t_d_n_m - t_display_no_money, 0, f_y, t_transition)
      
    elseif t_display_no_money < t_transition then
      y = f_y + s_y - easeInOut(t_transition - t_display_no_money, 0, f_y, t_transition)
      
    else
      y = f_y + s_y   
    end
    
    
    local str = " You need " .. 999 - my_money .. " more coins. "
    local h = 45
    local w = str_px_width(str)
    local spc = 5
    
    local x = sw/2 - w/2
    
    color(0)
    rectfill(x - spc , y - spc - h , x + w + spc , y + spc )    
    color(1)
    rectfill(x       , y       - h , x + w       , y       )    
    
    cool_print(str, x, y - h * 1.2)  
  end
end









