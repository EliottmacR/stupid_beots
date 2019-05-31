
local background_clr = 2
local this
local sw
local sh
-- local back_rect = {}

selected_game = nil
selected_index = 1

local top_index = 1
local displayed_games = {}
local t_display_no_money = 0
local max_t_d_n_m = 3.5

function init_choose_game(z)
  sw = GW
  sh = GH
  this = init_screen("choose_game",update_choose_game, draw_choose_game, background_clr, 0, 0, sw, sh, z )

  displayed_games = {}
  for i = 1, min(5, count(SB_games)) do
    displayed_games[i] = SB_games[i]
  end
  
  t_display_no_money = 0
  
  display_back = true
  
  selected_game = displayed_games[1] or nil
  
  return this
end


function update_choose_game(dt)

  if not selected_game and SB_games[top_index] then
    displayed_games = {}
    for i = 1, min(5, count(SB_games)) do
      displayed_games[i] = SB_games[i]
    end
    selected_game = SB_games[top_index] 
  end
  
  t_display_no_money = t_display_no_money - dt
  
  if not (TRANSIT) then
    if btn(4) and count(SB_games) > 5 then
      -- loop index for 5 games
      top_index = top_index + ((btnv(4) > 0) and -1 or 1)
      
      if top_index < 1 then top_index = count(SB_games)
      elseif top_index > count(SB_games) then top_index = 1 end
          
      for i = 1, min(5, count(SB_games)) do
        local index = top_index + (i-1)
          
        if index < 1 then index = count(SB_games) - index
        elseif index > count(SB_games) then index = index - count(SB_games) end
                
        displayed_games[i] = SB_games[index]
      end    
    end
    
    if btn(5) then 
      begin_transition_from_to(this,"title_screen")
    end
  end
  
end

function draw_choose_game()
  cls(background_clr)
  
  -- display all game on the right of the screen
      
    for i = 1, #displayed_games do
      local allx = sw - str_px_width(displayed_games[i].name) - 30 - 20
      local ally = (i-1) * str_px_height("9") * 1.6 - 50 + sh/(2 + min(#displayed_games, 5)/2.5)
      
      local x1_b = allx - 15
      local x2_b = allx + 15 + str_px_width(displayed_games[i].name) 
      local y1_b = ally + 3  + sin_buttons 
      local y2_b = ally + 3  + sin_buttons + str_px_height(displayed_games[i].name) + 5
      local border = 5
      local step = 10
            
      color(0)
      rectfill( x1_b + step, y1_b + step, x2_b + step, y2_b + step)                
                
      color(0)
      rectfill(x1_b,y1_b,x2_b,y2_b)
      
      color(background_clr)
      rectfill(x1_b + border,y1_b + border,x2_b - border,y2_b - border)
                
      if displayed_games[i] == selected_game then 
        color(5)
      elseif mouse_in_rect(x1_b,y1_b,x2_b,y2_b) then
        color(7)
        if btn(0) and displayed_games[i] then selected_game = displayed_games[i] selected_index = i end
      end
      
      rectfill( x1_b + border, y1_b + border, x2_b - border, y2_b - border)
                
      shaded_cool_print(displayed_games[i].name, allx , ally + sin_buttons , 0, 4)
      
    end
    
    if count(SB_games) > 5 then
      
      color(0)
      
      local x1 = sw   - 13
      local y1 = sh/4 - 50 + sin_buttons
      local x2 = sw   - 5
      local y2 = str_px_height("9") * 4.75 * 1.6 - 50 + sh/4 + sin_buttons
      
      color(0)
      rectfill( x1 , y1 , x2 , y2 )

      color(3)
      rectfill( x1 + 1 , y1 + 1 + (y2 - y1) / count(SB_games) * (top_index - 1), x2 - 1 , y1 - 1 + (y2 - y1) / count(SB_games) * top_index )
      
    end
  
    -- select button  
    
    local str = " Choose "    
    local x_select = sw * 3/4 - str_px_width(str)/2 + 25
    local y_select = sh - 50 - str_px_height(str)/2    
    local x1_b = x_select 
    local x2_b = x_select + str_px_width(str)
    local y1_b = y_select + sin_buttons/2 
    local y2_b = y_select + sin_buttons/2 + str_px_height(str)* 1.2    
    local border = 10
    local step = 10
    
    
    color(0)
    rectfill(x1_b + step, y1_b + step, x2_b + step, y2_b + step)  
    
    color(flr(t()) % 2 == 0 and 1 or 8 )
    rectfill(x1_b, y1_b, x2_b, y2_b) 
    
    color(background_clr)    
    rectfill( x1_b + border, y1_b + border, x2_b - border, y2_b - border)
              
    local c = 5  
    if mouse_in_rect(x1_b,y1_b,x2_b,y2_b) or btn(6) then
      c = 11
      if (not TRANSIT) and (btnp(0) or btnp(6)) then
        c = background_clr
        if my_money > 0 then
          begin_transition_from_to(this,"choose_bets")
        elseif t_display_no_money < 0 then
          t_display_no_money = max_t_d_n_m
        end      
      end      
    end      
    shaded_cool_print(str, x_select, y_select + sin_buttons/2 , 0, c)
    
  ---------------------------------------------------  
  ---------------------------------------------------  
  ---------------------------------------------------  
  
  -- display info of the selected game
  
  if selected_game then
    -- title
    
        use_font("very_big")
          very_cool_print(selected_game.name, sw * 1.2/4 , sh*.8/4 + sin_buttons, 7, 0)
        use_font("big")
      
    -- description
    
      -- rect
        local border = 20
        local x1 = 50 - border
        local y1 = sh / 3 - border + sin_buttons
        local x2 = sw / 2 + 25 + border
        local y2 = y1 + (#selected_game.description+1) * str_px_height("9") + border
        local step = 20
        color(0)
        rectfill(x1 + step, y1 + step, x2 + step, y2 + step)
            
        color(flr(t()) % 2 == 0 and 8 or 1 )
        rectfill(x1, y1, x2, y2)
        
        color(background_clr)
        rectfill(x1 + border, y1 + border, x2 - border, y2 - border)
    
      -- text
        use_font("description")
        for i = 1, #selected_game.description do 
          str = selected_game.description[i]
          
          shaded_cool_print(str, x1 + 10 + border, y1 + border + 20 + (i-1) * str_px_height("9"))
        end
        use_font("big")
        
    
    
    
  end
  
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
    
    
    local str = " You no longer have money. "
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
  
  shaded_cool_print("Coins:" .. my_money, str_px_width("9"), sh - str_px_height("9")*1.3 + sin_buttons, 0, 5 )
  
end

function easeInOut (timer, value_a, value_b, duration)
  
  timer = timer/duration*2  
	if (timer < 1) then return value_b/2*timer*timer + value_a end
  
	timer = timer - 1
  
 	return -value_b/2 * (timer*(timer-2) - 1) + value_a
end 
      