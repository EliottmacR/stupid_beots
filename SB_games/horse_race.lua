
-- require("assets/heads.png")
-- horse = require("horse.png")

local ct_bot_names
local number_of_games = 999

local horsepng = nil

function horse_race(names)
    
  local q = {}
  local a = {}
  local coefs = {}
  if not ct_bot_names then 
    ct_bot_names = {names[1] or "Trasevol Bot", names[2] or "BimBamBot"}
    -- ct_bot_names = {"BenjaminBoton" ,"BenjaminBoton"}
  end
  table.insert(q,"Who wins the race ?")
  table.insert(a,{ct_bot_names[1], ct_bot_names[2]})
  table.insert(coefs, 2.5)
  
  return 
  {
    name = "Horse Race !",
    description = {
                    "Two big stalions ready to ",
                    "race for the biggest bidder",
                    "if you are lucky. One race !",
                    "",
                    "More money for more thrill."
                    },
    q = q,
    a = a,
    coefs = coefs,
    b_names = b_names,
    
    init = init_horse_race,
    update = update_horse_race,
    draw = draw_horse_race
    
  }
  
end

------


local game_surf
local hr_background
local background_clr

local drawn_results = 0
local already_drawn = 0

sorted_bets = {}
local history = {}

local scale = 4

local night = false

x_horse_b1 = nil
x_horse_b2 = nil
length_race = nil

stars = {}
t_ang = 0

horse1 = nil
horse2 = nil

function init_horse_race(GW, GH, bclr)
  sw = GW
  sh = GH
  
  background_clr = bclr or 2
  
  init_functions_horse_race()
  history = {}
  sorted_bets = {}
  drawn_results = 0
  end_game_y = 0
  game_ended = false
  nexted = false
  
  length_race = 500
  game_surf = new_surface(ceil(sw * 3/4), ceil(sh * 3/4))
  hr_background = new_surface((length_race + 200) * scale, ceil(sh * 3/4))
  
  if not horse1 then
    horse1 = new_surface(64, 64)
  end
  if not horse2 then
    horse2 = new_surface(64, 64)
  end
  
  local col1 = irnd(15)
  while                 col1 == 0 or col1 == 1 or col1 == 2 or col1 == 5 do col1 = irnd(15) end
  local col2 = col1
  while col2 == col1 or col2 == 0 or col2 == 1 or col1 == 2 or col2 == 5 do col2 = irnd(15) end
  
  target(horse1)  
  
  rectfill(0, 0, 64, 64, col1 ) 
  palt(5, true)
  spr_sheet("horse", 0, 0, 64, 64)
  palt(5, false)
  
  target(horse2)  
  
  rectfill(0, 0, 64, 64, col2 ) 
  palt(5, true)
  spr_sheet("horse", 0, 0, 64, 64)
  palt(5, false)
  
  
  x_horse_b1  = 0
  x_horse_b2  = 0
  t_ang = 0
  
  
  night = irnd(2) == 1 and true or false
  winner = nil 
  
  if game_surf then
    target(game_surf)
    init_hr_surf()
    
    target(hr_background)
    init_hr_background()
    
    target()
  end
  
end

function update_horse_race(dt)
  
  t_ang = t_ang + dt / 5
  if nexted or btnp(1) then 
    nexted = false
    if game_ended and not TRANSIT then
      begin_transition_from_to(sb_screen,"display_results")
    else
      endgame()
    end
  end
  
  if x_horse_b1 < length_race + 10 or x_horse_b2 < length_race + 10 then
  
    if x_horse_b1 < length_race + 10 then
      x_horse_b1 = x_horse_b1 + ( chance(15) and (10) or 0 )
    else
      if not winner then winner = 1 end
    end
    
    if x_horse_b2 < length_race + 10 then
      x_horse_b2 = x_horse_b2 + ( chance(15) and (10) or 0 )
    else
      if not winner then winner = 2 end
    end
    
  elseif not game_ended then
    endgame()
  end
  
end

function draw_horse_race()

  
  if game_surf then
    target(game_surf)
    draw_each_play()
    target(sb_screen.surface)  

    
    palt(1, true)    
    spr_sheet(horse1,              15 , 75 , 64, 64)
    spr_sheet(horse2, target_w() - 15 - 64, 75 , 64, 64)   
    palt(1, false)
    
    use_font("description")
    shaded_cool_print(ct_bot_names[1], 15 + 64 + 10, 75) 
    shaded_cool_print(ct_bot_names[2], target_w() - 15 - 64*2 - 10 - str_px_width(ct_bot_names[2]), 75) 
    use_font("big")

    
    local w, h = surface_size(game_surf)
    spr_sheet(game_surf, (sw - w)/2 , sh - h - 15 + sin_buttons)
  end
  
  draw_advancement()
  
  if game_ended then
    draw_next_button()
  end
  

end


function init_hr_background()

  local w, h = surface_size(hr_background)
  
  cls(14)
  
  -- color(13) -- green
  rectfill(0, h*2/3, w, h, 13) 
  
  -- color(5) -- white
  rectfill(0, h*2/3 - 30, w, h*2/3, 5) 
  
  
  local unit = 50 * scale
  local start_x = unit/3
  
  for i = 0, w / 50  do
  
    big_line_h( start_x + i * unit, h * 1/2 + 50, start_x + i * unit + 25, h * 1/2 + 15, 10)
    
    big_line_v( start_x + i * unit, h * 1/2 + 50, start_x + i * unit     , h , 10)
    
    shaded_no_surlign_cool_print(i * 50 ,  start_x + i * 50 * scale + 25 + 5, h * 1/2 - 25)
  end
  

  local ww = 5
  local hh = 5
  local start_x = 50 * scale/3
  local x_dam = length_race * scale + start_x
  local y_dam = h * 2/3
  local s_rect = h * 1/3 / ww
  
  rectfill( x_dam, y_dam, x_dam + s_rect * ww, y_dam + s_rect * hh, 0)
            
  for i = 0, ww-1 do
    for j = 0, hh-1 do    
      if (i + j) % 2 == 0 then 
        rectfill( x_dam + s_rect * i, y_dam + s_rect * j, x_dam + s_rect * (i+1) , y_dam + s_rect * (j+1), 5 )                  
      end
    end
  end  
  
  
  local w, h = surface_size(hr_background)
  
  rectfill(6, h * 1/2 + h/2 * 1/3 + 50, w, h * 1/2 + h/2 * 1/3 + 10 + 50, 0)
  rectfill(6, h * 1/2 + h/2 * 2/3 + 50, w, h * 1/2 + h/2 * 2/3 + 10 + 50, 0)
  
end

function init_hr_surf()
  
  
  local w, h = surface_size(game_surf)
  
  if night then
    stars = {}
    local number_of_stars = 500
    local w, h = surface_size(hr_background)
    
    for i = 1, number_of_stars do
      table.insert(stars, {x = irnd(w), y = irnd(( h * 1/2 + 15) / 2)} )
    end
     
  end
  

end

function init_functions_horse_race()
  
  draw_each_play = function ()
  
    local w, h = surface_size(game_surf)
    
    local x = max(x_horse_b1 - 3 * 50 , 0)
    x = max(x_horse_b2 - 3 * 50, x)
    
    spr_sheet(hr_background, - x * scale , 0)  
  
    if night then
    
      rectfill(0, 0, w, ( h * 1/2 + 15) * 1/2, 15)
      
      for i, star in pairs(stars) do
        local c =  chance(3) and 4 or 5
        rectfill(star.x - 1, star.y, star.x + 1, star.y, c)
        rectfill(star.x, star.y - 1, star.x, star.y + 1, c)
      end
      
    else    
      rectfill(0, 0, w, ( h * 1/2 + 15) * 1/2, 3)
      
      local all_x = w / 2
      local all_y = 50      
      local w_t = 25
      local h_t = 35      
      local num_c = 8
      
      for i = 0 , (num_c-1) do       
        local angle = i/num_c + t_ang        
        trifill(  all_x + cos(angle + .25) * w_t/2, all_y + sin(angle + .25) * w_t/2,  
                  all_x + cos(angle - .25) * w_t/2, all_y + sin(angle - .25) * w_t/2,
                  all_x + cos(angle      ) * h_t  , all_y + sin(angle      ) * h_t, 4)        
      end  
      
      circfill(all_x, all_y, 25, 3)      
      circfill(all_x, all_y, 20, 4)      
      
    end
  
    local start_x = 50 * scale/3
    x = x * scale
     
    rectfill(start_x + x_horse_b1 * scale - x - 3, h*2/3      + 15, start_x + x_horse_b1* scale - x + 3, h*2/3 + 40      + 15, 0)    
    rectfill(start_x + x_horse_b2 * scale - x - 3, h*2/3 + 80 + 15, start_x + x_horse_b2* scale - x + 3, h*2/3 + 40 + 80 + 15, 0)
    
    palt(1, true)    
    spr_sheet(horse1, start_x + x_horse_b1 * scale - 32 - x, h*2/3 - 15     , 64, 64)
    spr_sheet(horse2, start_x + x_horse_b2 * scale - 32 - x, h*2/3 + 40 + 15 , 64, 64)    
    palt(1, false)
    
    if winner then
      local str = ct_bot_names[winner] .. " won !"
      shaded_cool_print(str, w/ 2 - str_px_width(str)/2, 100 + sin_buttons)
    end
    
  end
  
  draw_advancement = function () -- advancement of the game
  
  end
  
  draw_winner = function () 

  end
  
  endgame = function ()
    if nexted then return end
    
    sugar.audio.sfx ("selected") 
  
    while not winner do
    
      if x_horse_b1 < length_race + 10 then
        x_horse_b1 = x_horse_b1 + ( chance(15) and (10) or 0 )
      else
        if not winner then winner = 1 end
      end
      
      if x_horse_b2 < length_race + 10 then
        x_horse_b2 = x_horse_b2 + ( chance(15) and (10) or 0 )
      else
        if not winner then winner = 2 end
      end
      
    end
    
    game_ended = true
    
    drawn_results = number_of_games     
    history_to_bet_coin_toss()
    
  end

  history_to_bet_coin_toss = function ()

  -- history is a table of number of game that occured and the results

    local h = history
    local bets = {}
    
    local g = horse_race()
    
    local pre_sorted_bets = {}
    
   
    for index, _ in pairs(sb_rules) do
      
      local index_q = flr(index / 10)
       
      local achieved = false
      local questions = g.q
      local t_result_bet
      
      
      ---------------------------------
      if index_q == 1 then
      
        t_result_bet = ct_bot_names[winner]
        -- log(t_result_bet)
        achieved = (t_result_bet == g.a[index_q][index - index_q*10])
        -- log(g.a[index_q][index - index_q*10])
        -- log(achieved and "true" or "false")
      
      end
      
      ---------------------------------
      
      if g.q[index_q] and g.a[index_q][index - index_q*10] and t_result_bet then  
      
      table.insert(pre_sorted_bets, { ["a"] = {question = g.q[index_q], betted_on = g.a[index_q][index - index_q*10], t_result = t_result_bet, achieved = achieved} , ["index_q"] = index_q} )
      
      end
    end
    --]]
    
    -- sort bets according to index of question
    local ind = 1
    
    for i = 1, #g.q do
      -- for each question, if found then add to sorted bet
      for j, ta in pairs(pre_sorted_bets) do
        if ta.index_q == i then
          sorted_bets[ind] = ta.a
          ind = ind + 1
        end
      end
    end

    return sorted_bets

    end
end

