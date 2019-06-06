
local background_clr = 2
local this
local sw
local sh
-- local back_rect = {}

local selected_game = nil

local top_index = 1
local displayed_games = {}

function init_main_menu(z)
  sw = GW
  sh = GH
  this = init_screen("main_menu",update_main_menu, draw_main_menu, background_clr, 0, 0, sw, sh, z )
  
  displayed_games = {}
  for i = 1, min(5, count(SB_games)) do
    displayed_games[i] = SB_games[i]
  end
  
  selected_game = displayed_games[1] or nil
  
  
  -- displayed_games = SB_games

  -- back_rect.str = " Back! "  
  -- back_rect.border = 10 
  
  -- back_rect = {
    -- x1 = sw / 2 - str_px_width(back_rect.str)/2 - back_rect.border,
    -- y1 = sh * 4 / 5 - back_rect.border ,
    -- x2 = sw / 2 + str_px_width(back_rect.str)/2 - 13 + back_rect.border,
    -- y2 = sh * 4 / 5 + str_px_height(back_rect.str) * 1.4 + back_rect.border,
    -- xt = sw / 2,
    -- yt = sh * 4 / 5,
    -- border = 10,
    -- hovered = false
  -- }
  -- back_rect.str = "Back!"  
  -- back_rect.border = 10 
  
  return this
end

local sin_buttons = 0

function update_main_menu(dt)

  if not selected_game and SB_games[top_index] then
    displayed_games = {}
    for i = 1, min(5, count(SB_games)) do
      displayed_games[i] = SB_games[i]
    end
    selected_game = SB_games[top_index] 
  end
  
  sin_buttons = sin(t() / 2) * 5
  
  
  if btnp(4) and count(SB_games) > 5 then
    -- loop index for 5 games
    top_index = ((top_index + ((btnv(4) > 0) and -1 or 1) ) - 1) % count(SB_games) + 1
    
    for i = 1, min(5, count(SB_games)) do
      local index = (top_index + i - 1) % count(SB_games) + 1
      displayed_games[i] = SB_games[index]
    end
    
    
  end
  -- back_rect.hovered = mouse_in_rect_screen(this, back_rect.x1, back_rect.y1, back_rect.x2, back_rect.y2)
  
  -- if not (count(transitioning) > 1) then
    -- if btn(0) and back_rect.hovered then 
      -- begin_transition_from_to(this,"title_screen")
    -- end
  -- end
  
end

function draw_main_menu()
  cls(background_clr)
  
  very_cool_print(" Choose a game!", sw * 3/4 , 40)
  
  -- display all game on the right of the screen
      
    for i = 1, #displayed_games do
      local allx = sw - str_px_width(displayed_games[i].name) - 30 
      local ally = sh/4 + (i-1) * str_px_height("9") * 1.6 - 50
      
      local x1_b = allx - 15
      local x2_b = allx + 15 + str_px_width(displayed_games[i].name) 
      local y1_b = ally + 3  + sin_buttons 
      local y2_b = ally + 3  + sin_buttons + str_px_height(displayed_games[i].name) + 5
      mouse_in_rect(x1_b,y1_b,x2_b,y2_b)
      local border = 5
      
      color(0)
      rectfill(x1_b,y1_b,x2_b,y2_b)
      
      color(background_clr)
      if displayed_games[i] == selected_game then 
        color(5)
      elseif mouse_in_rect(x1_b,y1_b,x2_b,y2_b) then
        color(7)
        if btn(0) and displayed_games[i] then selected_game = displayed_games[i] end
      end
      
      rectfill( x1_b + border,
                y1_b + border,
                x2_b - border,
                y2_b - border)
                
      cool_print(displayed_games[i].name, allx , ally + sin_buttons , 0, 4)
      
    end
  
    -- select button    
    local str = " S E L E C T "    
    local x_select = sw * 3/4 - str_px_width(str)/2
    local y_select = sh - 50 - str_px_height(str)/2    
    local x1_b = x_select 
    local x2_b = x_select + str_px_width(str)
    local y1_b = y_select + sin_buttons/2 
    local y2_b = y_select + sin_buttons/2 + str_px_height(str)* 1.2    
    local border = 10
      
    color(0)
    rectfill(x1_b,y1_b,x2_b,y2_b)    
    color(13)    
    rectfill( x1_b + border,
              y1_b + border,
              x2_b - border,
              y2_b - border)
              
    local c = 4   
    if mouse_in_rect(x1_b,y1_b,x2_b,y2_b) then
      c = 7
      if btn(0) then
        c = background_clr
      end      
    end      
    cool_print(str, x_select, y_select + sin_buttons/2 , 0, c)
    
  -- display info of the selected game
  
  
  -- title
  if selected_game then
    very_cool_print(selected_game.name, sw * 1/4 , sh/8, 7, 0)
  end
  
  
  -- description
  
  local border = 20
  local x1 = 50 - border
  local y1 = sh / 2 - border + sin_buttons
  local x2 = sw / 2 - 50 + border
  local y2 = sh - 50 + border + sin_buttons
  
  color(0)
  rectfill(x1, y1, x2, y2)
  
  color(background_clr)
  rectfill(x1 + border, y1 + border, x2 - border, y2 - border)
  
  
  
  -- draw_button(back_rect)  
end