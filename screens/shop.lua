
local background_clr = 2
local this -- screen
local sw
local sh

local play_rect = {}
local shop_rect = {}

function init_shop(z)
  sw = GW
  sh = GH
  this = init_screen("shop",update_shop, draw_shop, background_clr, 0, 0, sw, sh, z or 1)
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
  shop_rect.str = " Shop "  
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
  shop_rect.str = "Shop"  
  shop_rect.border = 10 
   
  
  display_back = false
  return this
end

function update_shop(dt)

  play_rect.hovered = mouse_in_rect_screen(this, play_rect.x1, play_rect.y1, play_rect.x2, play_rect.y2)
  shop_rect.hovered = mouse_in_rect_screen(this, shop_rect.x1, shop_rect.y1, shop_rect.x2, shop_rect.y2)
  
  if not TRANSIT then
    if btnp(0) and play_rect.hovered then 
      begin_transition_from_to(this,"choose_game")
    end
    if btnp(0) and shop_rect.hovered then 
      begin_transition_from_to(this,"shop")
    end
  end
end

function draw_shop()
  cls(background_clr)
  very_cool_print("Stupid Beots !", sw / 2 , 40)
  
  draw_button(play_rect)    
  draw_button(shop_rect)  
  
  shaded_cool_print("Coins:" .. my_money, str_px_width("9"), sh - str_px_height("9")*1.3 + sin_buttons, 0, 5 )
  
end









