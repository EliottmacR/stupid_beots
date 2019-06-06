
local background_clr = 2
local this -- screen
local sw
local sh

local play_rect = {}
local shop_rect = {}
local beg_rect = {}

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
  
  ------ beg button
  
  beg_rect.str = " Search "  
  beg_rect.border = 10 
  
  beg_rect = {
    x1 = sw - 100   - str_px_width(beg_rect.str)/2 - beg_rect.border - 20,
    y1 = sh - 100 - beg_rect.border ,
    x2 = sw - 100     + str_px_width(beg_rect.str)/2 - 13 + beg_rect.border - 20,
    y2 = sh - 100 + str_px_height(beg_rect.str) * 1.4 + beg_rect.border,
    xt = sw - 100 - 20,
    yt = sh - 100,
    border = 10,
    hovered = false
  }
  beg_rect.str = "Search"  
  beg_rect.border = 10 
   
  
  display_back = false
  return this
end

function update_title_screen(dt)

  t_display_no_money = t_display_no_money - dt
  
  local before = play_rect.hovered 
  play_rect.hovered = mouse_in_rect_screen(this, play_rect.x1, play_rect.y1, play_rect.x2, play_rect.y2)
  if not before and play_rect.hovered and not TRANSIT then sugar.audio.sfx ("selection") end
  
  local before = shop_rect.hovered 
  shop_rect.hovered = mouse_in_rect_screen(this, shop_rect.x1, shop_rect.y1, shop_rect.x2, shop_rect.y2)
  if not before and shop_rect.hovered and not TRANSIT then sugar.audio.sfx ("selection") end
  
  local before = beg_rect.hovered 
  beg_rect.hovered  = not clicked_beg and mouse_in_rect_screen(this, beg_rect.x1, beg_rect.y1, beg_rect.x2, beg_rect.y2)
  if not before and beg_rect.hovered and not TRANSIT then sugar.audio.sfx ("selection") end
  
  if not btnp(0) then
    clicked_beg = false
  end
  
  -- if btnp(1) then
    -- network.async(function () erase_money() log("erased") end)
  -- end
  
  if not TRANSIT then 
    if btnp(0)then 
      if play_rect.hovered and wg_done then 
        sugar.audio.sfx ("selected")
        begin_transition_from_to(this,"choose_game")
      end
      if shop_rect.hovered and wg_done then 
        sugar.audio.sfx ("selected")
        if t_display_no_money < 0 then 
            max_t_d_n_m = 3.5 
          if my_money then
            if my_money >= 999 then
              max_t_d_n_m = 15
              if wg_done then init_winground(2) end              
            end        
          end  
          t_display_no_money = max_t_d_n_m            
        end    
      end
      if beg_rect.hovered and wg_done then 
        sugar.audio.sfx ("selected")
        clicked_beg = true
        if chance(10) and my_money < 10 then 
          my_money = my_money + 1 
          network.async(function () save_money() end)
        end      
      end
    end
  end
  
end

function draw_title_screen()
  cls(background_clr)
  very_cool_print("Stupid Beots !", sw / 2 , 40)
  draw_button(play_rect)    
  draw_button(shop_rect)  
  if loaded_money then
    shaded_cool_print("Coins:" .. my_money, str_px_width("9"), sh - str_px_height("9")*1.3 + sin_buttons, 0, 5 )
  else
    very_cool_print("Loading...", str_px_width("  Loading...")/2, sh - str_px_height("9")*1.3 + sin_buttons, 0, 5 )
  end
  
  draw_button(beg_rect)
  
  
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
    
    
    local str = not loaded_money and "Waiting for money..." 
                or (my_money < 999 and " You need " .. 999 - my_money .. " more coins. " 
                    or "Congratulations " ..(castle.user.getMe().name or castle.user.getMe().username or "" ) .." !!!"
                    )
                    
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
  
  use_font("description")
  lesser_cool_print("Made by Eliott", sw/2, sh - 10)
  use_font("big")
  
  
  
  local wi = 32+16
  local offset
  local x
  local y
  
  -- help
    x = 20
    y = 80
    offset = mouse_in_rect( x, y + sin_buttons, x + wi, y + sin_buttons + wi) and 5 or 0
    
    if offset > 0 then
      if not helped then 
        helped = not helped 
      end
    else 
      helped = false
    end
    
    y = 150 + sin_buttons*2
    
    if helped then
      use_font("description")
      
      local cnt = 4
      local wt = str_px_width("Press LMB to go backward") + 30
      local ht = 20 + 40 * cnt
      rectfill(x, y, x + wt, y + ht, 0)
      rectfill(x + 5, y + 5, x + wt - 5, y + ht - 5, background_clr)
      
        shaded_cool_print("Press RMB to go backward", x + 15, y + 15)
        shaded_cool_print("in menus.", x + 15, y + 15 + 40)
        shaded_cool_print("Also press it to skip", x + 15, y + 15 + 80)
        shaded_cool_print("game animations.", x + 15, y + 15 + 120)
      
      use_font("big")
    
    
    
    
    
    end
    
    y = 80
    
    circfill(x + wi/2 + 5, y + sin_buttons + wi/2 + 5, (wi-offset - 4)/2, 0)
    palt(1, true)
    spr_sheet("help", x - offset, y + sin_buttons - offset, wi, wi)
    palt(1, false)
    
  
  -- sound
  
    y = 20
    
    offset = mouse_in_rect( x, y + sin_buttons, y + wi, y + sin_buttons + wi) and 5 or 0
    
    if btnp(0) and offset > 0 then 
      muted = not muted 
      music_volume( muted and 0 or 1)
    end
    
    circfill(y + wi/2 + 5, y + sin_buttons + wi/2 + 5, (wi-offset - 4)/2, 0)
    palt(1, true)
    spr_sheet(muted and "no_sound" or "sound", y - offset, y + sin_buttons - offset, wi, wi)
    palt(1, false)
  
  
  
  
  
  
  
  
  
end
