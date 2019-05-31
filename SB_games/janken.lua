
-- require("assets/heads.png")
-- require("assets/tails.png")

local ct_bot_names
local number_of_games = 999

function janken(names)
    
  function q_a()
  
    local q = {}
    local a = {}
    local coefs = {}
    if not ct_bot_names then 
      ct_bot_names = {names[1] or "Trasevol Bot", names[2] or "BimBamBot"}
      -- ct_bot_names = {"BenjaminBoton" ,"BenjaminBoton"}
    end
    table.insert(q,"Who wins out of the " .. number_of_games .. " plays ?")
    table.insert(a,{ct_bot_names[1], ct_bot_names[2], "Neither"})
    table.insert(coefs,3 * 1.25)
    
    table.insert(q,"Who wins the first with rock ?")
    table.insert(a,{ct_bot_names[1], ct_bot_names[2]})
    table.insert(coefs,2 * 1.25)
    
    table.insert(q,"Who wins the last with rock ?")
    table.insert(a,{ct_bot_names[1], ct_bot_names[2]})
    table.insert(coefs,2 * 1.25)
    
    table.insert(q,"Who will play the most with paper ?")
    table.insert(a,{ct_bot_names[1], ct_bot_names[2]})
    table.insert(coefs,2 * 1.25)
    
    table.insert(q,"Number of draw > 1/3 of the games ?")
    table.insert(a,{"Yes", "No"})
    table.insert(coefs,2 * 1.25)
  
    return q, a, coefs, ct_bot_names
  
  end
  
  local questions, answers, coefs, b_names = q_a()
  
  return 
  {
    name = "Janken !",
    description = {
                    "Rock, Paper, Scissors ! ",
                    "Probably the first game where",
                    "you can beat your opponent with ",
                    "a sheet of paper. " .. number_of_games .. " plays!"
                    },
    q = questions,
    a = answers,
    coefs = coefs,
    b_names = b_names,
    
    init = init_janken,
    update = update_janken,
    draw = draw_janken
    
  }
  
end

------


local background_clr

local history = {}
local xp, yp, strp = {}, {}, {}
local drawn_results = 0

local vborder_from_edge = 100
local hborder_from_edge = 200

sorted_bets = {}

local game_surf

local already_drawn = 0

function init_janken(GW, GH, bclr)
  sw = GW
  sh = GH
  
  background_clr = bclr or 2
  
  init_functions_janken()
  history = {}
  sorted_bets = {}
  drawn_results = 0
  end_game_y = 0
  game_ended = false
  nexted = false
  
  game_surf = new_surface(ceil(sw * 2/3), ceil(sh * 2/3))
  
  if game_surf then
    target(game_surf)
    init_janken_surf()
    target()
  end  

  -- 1: rock, 2:paper, 3:scissors  
  for i = 1, number_of_games do
    history[i] = { 1 + irnd(3),  1 + irnd(3)}        
  end
  
  y_offset = 0
  
end

function update_janken(dt)

  if drawn_results < number_of_games then
    drawn_results = drawn_results + dt * min((drawn_results+.6), number_of_games / 7)
    drawn_results = min(drawn_results,number_of_games)
        
  else
    endgame()
  end
  
  if nexted then
    if y_offset > 0 then
      y_offset = flr(y_offset * 0.95)
      y_offset = y_offset - 1
    else
      y_offset = max(-240, y_offset * - 1.05 *- 1)
    end
  else
    y_offset = min(flr(drawn_results),number_of_games)/number_of_games * min(flr(drawn_results),number_of_games)/number_of_games * 300
  end
  
  if btn(6) then 
    endgame()
  end
  
end

function draw_janken()

  
  if game_surf then
    -- log("there")
    target(game_surf)
    draw_each_play()
    target()
    
    local w, h = surface_size(game_surf)
    
    palt(background_clr, true)
    spr_sheet(game_surf, (sw - w)/2 , (sh - h)*3/5 + sin_buttons)
    palt(background_clr, false)
  end
  
  draw_advancement()
  
  -- draw_play_results_bar()
  
  if game_ended then
    draw_next_button()  
    if y_offset == -240 then
      draw_winner()    
    end
  end
  

end

function winner_of_janken(num_of_game)
  if num_of_game < 1 or num_of_game > number_of_games then return end
  
  local c1 = history[num_of_game][1]
  local c2 = history[num_of_game][2]
  
  return rps_result(history[num_of_game][1], history[num_of_game][2])

end

function rps_result(move1, move2)
  if not move1 or not move2 then return end
  
  local c1 = move1
  local c2 = move2
  -- 1: rock, 2:paper, 3:scissors  
  
  if c1 == c2 then return 0 end
    
  if c1 == 1 then
    return c2 == 2 and 2 or 1 
  elseif c1 == 2 then
    return c2 == 3 and 2 or 1 
  else -- c1 == 3  
    return c2 == 1 and 2 or 1     
  end
  

end


local moves = {"Rock", "Paper", "Scissors"}

function init_janken_surf()

  local surf_w = ceil(sw * 2/3)
  local surf_h = ceil(sh * 2/3)
  
  local border = 5
  jrw = (surf_w - border) / 4 - border
  jrh = (surf_h - border) / 4 - border
  
  
  cls(0)
  
  for i = 1, 4 do
    for j = 1, 4 do
      local x = border * j + (j-1) * jrw
      local y = border * i + (i-1) * jrh
      color(background_clr)
      rectfill( x, y, x + jrw, y + jrh)  
      
      if j == 1 and i > 1 then
        cool_print(moves[i-1]:sub(1,1), x + jrw/2 - 10, y + jrh/2 - 25)
      elseif i == 1 and j > 1 then
        cool_print(moves[j-1]:sub(1,1), x + jrw/2 - 10, y + jrh/2 - 25)
      end
      
      if j > 1 and i > 1 then
        local res = rps_result(i-1, j-1)
        local str = res == 0 and "DRW" or res == 1 and "WB1" or res == 2 and "WB2"
        
        cool_print(str, x + jrw/2 - 35, y + jrh/2 - 25)
      
      end
      
    end
  end
  
  
  local x1 = border + jrw*1/4  
  local y1 = border + jrh*2/3
  
  cool_print("B1", x1 - 15, y1 - 20)
  
  local x2 = border + jrw*2/3 
  local y2 = border + jrh*1/4
  
  cool_print("B2", x2 - 5, y2 - 20)
  
  line(border, border-1-1, jrw + border + 5, jrh + border-1-1+ 5, 0)
  line(border, border-1  , jrw + border + 5, jrh + border-1  + 5, 0)
  line(border, border    , jrw + border + 5, jrh + border    + 5, 0)
  line(border, border+1  , jrw + border + 5, jrh + border+1  + 5, 0)
  line(border, border+1+1, jrw + border + 5, jrh + border+1+1+ 5, 0)
  


end

function init_functions_janken()
  
  draw_each_play = function ()
    color(0)
    for i = already_drawn + 1, min(flr(drawn_results),number_of_games) do
    
      local border = 5
      local x_circ = border + jrw + border + (history[i][2]-1) * (jrw + border)
      local y_circ = border + jrh + border + (history[i][1]-1) * (jrh + border)
      
      circfill(x_circ + jrw/6 + irnd(jrw * 4/6), y_circ + jrh/6 + irnd(jrh * 4/6), 4)
      
    end    
    already_drawn = flr(drawn_results)
  end
  
  draw_advancement = function () -- advancement of the game

    local xb, yb, border = 20, 20, 5
    color(12)
    rectfill(xb, yb, sw - 20, yb + 60)
    color(8)
    rectfill(xb + border, yb + border, sw - xb - border, yb + 60 - border)
    color(0)
    rectfill(xb + border + (sw-(xb + border)*2)/number_of_games*flr(drawn_results), yb + border, sw - xb - border, yb + 60 - border)
    
    local str = flr((drawn_results/ number_of_games) * 100) .. " %"
    shaded_cool_print(str, sw / 2 - str_px_width(str)/ 2,  20 + sin_buttons, 11, 5)

  end
  
  draw_winner = function () 
    -- local str
    -- if winb1> number_of_games/2 then
      -- str = "The Winner is : " .. ct_bot_names[1] .. " !"
    -- elseif winb1< number_of_games/2 then
      -- str = "The Winner is : " .. ct_bot_names[2] .. " !"
    -- else
      -- str = "It's a draw !"  
    -- end
    
    -- very_cool_print(str, sw / 2, sh - 100, nil, nil, 5,  10)

  end
  
  endgame = function ()
    if nexted then return end
    
    game_ended = true
    nexted = true
    end_game_y = -1
    
    drawn_results = number_of_games     
    history_to_bet_coin_toss()
    
  end

  history_to_bet_coin_toss = function ()

  -- history is a table of number of game that occured and the results

    local h = history
    local bets = {}
    
    local g = coin_toss()
    
    local pre_sorted_bets = {}
    
    for index, _ in pairs(sb_rules) do
      
      local index_q = flr(index / 10)
       
      local achieved = false
      local questions = g.q
      local t_result_bet
      
      -- table.insert(q,"Who wins out of the 200 tosses ?")  -- 1
      -- table.insert(q,"Who wins the first Coin toss ?")    -- 2
      -- table.insert(q,"Who wins the last Coin toss ?")     -- 3
      
      ---------------------------------
      if index_q == 1 then -- {question = questions[index_q], betted_on = ct_bot_names[index - index_q], t_result = t_result_bet, achieved = achieved}
      
        -- local winner_is_1 = 0
        
        -- for i, winner in pairs(h) do
          -- winner_is_1 = winner_is_1 + (winner == 1 and 1 or 0)      
        -- end
         
        -- t_result_bet = "Draw"
        -- local result_bet   = 0
        
        -- if winner_is_1> number_of_games/2 then 
          -- result_bet = 1
          
        -- elseif winner_is_1 < number_of_games/2 then
          -- result_bet = 2
          
        -- end
        
        -- if result_bet ~= 0 then 
          -- t_result_bet = ct_bot_names[result_bet]
        -- end
        
        -- achieved = (result_bet == (index - index_q*10))
      
      
      elseif index_q == 2 then -- {question = questions[index_q], betted_on = ct_bot_names[index - index_q], t_result = t_result_bet, achieved = achieved}
        
        -- t_result_bet = ct_bot_names[h[1]]
        
        -- if h[1] == (index - index_q*10) then 
          -- achieved = true
        -- end
      
      -- elseif index_q == 3 then -- {question = questions[index_q], betted_on = ct_bot_names[index - index_q], t_result = t_result_bet, achieved = achieved}
      
        -- t_result_bet = ct_bot_names[h[number_of_games]]      
        
        -- if h[number_of_games] == (index - index_q*10) then 
          -- achieved = true
        -- end
      
      end
      
      --------------------------------------
      
      if questions[index_q] and ct_bot_names[index - index_q*10] and t_result_bet then 
      
      local b = {question = questions[index_q], betted_on = ct_bot_names[index - index_q*10], t_result = t_result_bet, achieved = achieved}
      
      table.insert(pre_sorted_bets, { ["a"] = {question = questions[index_q], betted_on = ct_bot_names[index - index_q*10], t_result = t_result_bet, achieved = achieved} , ["index_q"] = index_q}  )
      end
    end
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

