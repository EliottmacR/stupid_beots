
-- require("assets/heads.png")
-- require("assets/tails.png")

local ct_bot_names
local number_of_games = 1000


draw_each_play = nil
draw_advancement = nil
draw_play_results_bar = nil
draw_next_button = nil
draw_winner = nil 
endgame = nil
history_to_bet_coin_toss = nil


function coin_toss(names)
    
  local q = {}
  local a = {}
  local coefs = {}
  if not ct_bot_names then 
    ct_bot_names = {names[1] or "Trasevol Bot", names[2] or "BimBamBot"}
    -- ct_bot_names = {"Botman" ,"Angel Bot"}
  end
  table.insert(q,"Who wins out of the " .. number_of_games .. " tosses ?")
  table.insert(a,ct_bot_names)
  table.insert(coefs,2 * 1.25)
  
  table.insert(q,"Who wins the first Coin toss ?")
  table.insert(a,ct_bot_names)
  table.insert(coefs,2 * 1.25)
  
  table.insert(q,"Who wins the last Coin toss ?")
  table.insert(a,ct_bot_names)
  table.insert(coefs,2 * 1.25)
  
  return 
  {
    name = "Coin toss !",
    description = {
                    "A coin is flipped, " .. number_of_games .. " times",
                    "50/50, equal chances of ",
                    "winning. Do your best.",
                    "",
                    "Better for low-budget,",
                    "low chance bets and high reward."
                    },
    q = q,
    a = a,
    coefs = coefs,
    b_names = b_names,
    
    init = init_coin_toss,
    update = update_coin_toss,
    draw = draw_coin_toss
    
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

function init_coin_toss(GW, GH, bclr)
  sw = GW
  sh = GH
  
  background_clr = bclr or 2
  init_functions_coin_toss()
  
  history = {}
  sorted_bets = {}
  number_of_games = 400
  xp, yp, strp = {}, {}, {}
  drawn_results = 0
  winb1 = 0
  end_game_y = 0
  game_ended = false
  nexted = false
  
  for i = 1, number_of_games do
    history[i] = 1 + irnd(2)    
    strp[i] = history[i]==1 and {"Heads ! ", ct_bot_names[1]} or {"Tails ! ", ct_bot_names[2]}
    xp[i]    = 25 + irnd(sw - str_px_width(strp[i][1] .. strp[i][2] .. " won the round.") - 50)
    yp[i]    = 100 + irnd(sh - 300)
  end
  
  y_offset = 0
  
end

local winb1 = 0

function update_coin_toss(dt)

  if drawn_results < number_of_games then
    drawn_results = drawn_results + dt * min((drawn_results+.6), 50)
    drawn_results = min(drawn_results,number_of_games)
    
    winb1 = 0
    for i = 1, min(flr(drawn_results),number_of_games)  do
      if history[i] == 1 then winb1 = winb1 + 1 end
    end
    
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
  
  if btnp(1) then 
    endgame()
  end
  
end

function draw_coin_toss()

  draw_each_play()
  
  draw_advancement()
  
  draw_play_results_bar()
  
  if game_ended then
    draw_next_button()  
    if y_offset == -240 then
      draw_winner()    
    end
  end
  

end
  
function draw_next_button()
  local n_str = " > > "
  local x1 = sw - str_px_width(n_str)/2 -5
  local y1 = sh * 2/3 +5 + sin_buttons
  local x2 = x1 + str_px_width(n_str)-5
  local y2 = y1 + str_px_height(n_str)+5
  
  color(10)
  rectfill(x1, y1, x2, y2)
  
  if not TRANSIT and mouse_in_rect(x1, y1, x2, y2) and btnp(0) then
    sugar.audio.sfx ("selected") 
    color(0)
    if not nexted then nexted = true end_game_y = -1
    elseif y_offset < -238 and not TRANSIT then 
      log("transit")
      begin_transition_from_to(sb_screen,"display_results")
    elseif nexted then y_offset = -240 end
  else
    color(5)
  end
  
  rectfill(x1 + 5, y1 + 5, x2 - 5, y2 - 5)
  cool_print(n_str, x1 , y1 )
end


function init_functions_coin_toss()

  draw_each_play = function ()
  
    for i = max(1, flr(drawn_results) - 100), min(flr(drawn_results),number_of_games)  do
      local str = strp[i][1] .. strp[i][2] .. " won the round."
      color(0)
      rectfill(xp[i] - 10, yp[i]- 10, xp[i] + str_px_width(str) + 10, yp[i] + str_px_height(str) + 10)
      color(1)
      rectfill(xp[i] - 5 , yp[i]- 5 , xp[i] + str_px_width(str) + 5 , yp[i] + str_px_height(str) + 5 )
      
      shaded_cool_print(strp[i][1],        xp[i]                                          , yp[i])
      shaded_cool_print(strp[i][2],        xp[i] + str_px_width(strp[i][1])               , yp[i], 5, 10)
      shaded_cool_print(" won the round.", xp[i] + str_px_width(strp[i][1] .. strp[i][2]) , yp[i])
      
    end
  end
  
  
  draw_play_results_bar = function () -- advancement of the game
  
    local xb, yb, border = 20, sh - 100 + y_offset + end_game_y, 5
    
    color(0)
    rectfill(xb, yb, sw - 20, yb + 60)
    color(8)
    rectfill(xb + border, yb + border, sw - xb - border, yb + 60 - border)
    color(4)
    rectfill(xb + border + (sw-(xb + border)*2)/flr(drawn_results)*winb1, yb + border, sw - xb - border, yb + 60 - border)
    
    color(0)
    rectfill(sw/2 - 1, yb + border, sw/2 + 1, yb + 60 - border)
      
    if nexted and y_offset > -235 then
      color(0)
      rectfill(xb, yb, sw - 20, yb + 60)
    end
    
    local str = ct_bot_names[1]  .. " V.S " .. ct_bot_names[2]
    
    shaded_cool_print(ct_bot_names[1], sw / 2 - str_px_width(ct_bot_names[1])- str_px_width(" V.S ")/ 2,  yb + sin_buttons, 11, 5)
    
    shaded_cool_print(" V.S ", sw / 2 - str_px_width(" V.S ")/ 2,  yb + sin_buttons, 11, 5)
    
    shaded_cool_print(ct_bot_names[2], sw / 2 + str_px_width(" V.S ")/ 2,  yb + sin_buttons, 11, 5)

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
    local str
    if winb1> number_of_games/2 then
      str = "The Winner is : " .. ct_bot_names[1] .. " !"
    elseif winb1< number_of_games/2 then
      str = "The Winner is : " .. ct_bot_names[2] .. " !"
    else
      str = "It's a draw !"  
    end
    
    very_cool_print(str, sw / 2, sh - 100, nil, nil, 5,  10)
  end
  
  endgame = function ()
  
    if nexted then return end      
    game_ended = true
    nexted = true
    end_game_y = -1
    winb1 = 0
    for i = 1 ,number_of_games  do
      if history[i] == 1 then winb1 = winb1 + 1 end
    end      
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
      
        local winner_is_1 = 0
        
        for i, winner in pairs(h) do
          winner_is_1 = winner_is_1 + (winner == 1 and 1 or 0)      
        end
         
        t_result_bet = "Draw"
        local result_bet  = 0
        
        if winner_is_1> number_of_games/2 then 
          result_bet = g.a[index_q][1]
          
        elseif winner_is_1 < number_of_games/2 then
          result_bet = g.a[index_q][2]
          
        end
        
        if result_bet ~= 0 then 
          t_result_bet = ct_bot_names[result_bet]
          t_result_bet = result_bet
        end
        
        achieved = (result_bet == g.a[index_q][index - index_q*10] )
      
      
      elseif index_q == 2 then -- {question = questions[index_q], betted_on = ct_bot_names[index - index_q], t_result = t_result_bet, achieved = achieved}
        
        t_result_bet = ct_bot_names[h[1]]
        
        if ct_bot_names[h[1]] == g.a[index_q][index - index_q*10] then 
          achieved = true
        end
      
      elseif index_q == 3 then -- {question = questions[index_q], betted_on = ct_bot_names[index - index_q], t_result = t_result_bet, achieved = achieved}
      
        t_result_bet = ct_bot_names[h[number_of_games]]      
        
        if ct_bot_names[h[number_of_games]] == g.a[index_q][index - index_q*10] then 
          achieved = true
        end
      
      end
      
      --------------------------------------
      
      if g.q[index_q] and g.a[index_q][index - index_q*10] and t_result_bet then 
      
      local b = {question = g.q[index_q], betted_on = g.a[index_q][index - index_q*10], t_result = t_result_bet, achieved = achieved}
      
      table.insert(pre_sorted_bets, { ["a"] = {question = g.q[index_q], betted_on = g.a[index_q][index - index_q*10], t_result = t_result_bet, achieved = achieved} , ["index_q"] = index_q}  )
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

