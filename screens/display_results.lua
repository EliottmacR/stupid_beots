local background_clr = 2
local this
local sw
local sh

local step = 0
local bets = {}
local y_anim = 0
local won_bet = false -- true if all bets are won, it means the player won his money

function init_display_results(z)
  sw = GW
  sh = GH
  this = init_screen("display_results",update_display_results, draw_display_results, background_clr, 0, 0, sw, sh, z or 1 )  
  
  bets = sorted_bets -- {question = questions[index_q], betted_on = ct_bot_names[index - index_q], t_result = t_result_bet, achieved = achieved}
  moving = true
  step = 1
  won_bet = true
  sugar.audio.sfx ("selected") 
  
  for index, b in pairs(sorted_bets) do
    if not b.achieved then won_bet = false end
  end
  
  my_money = (won_bet and (flr(my_money + betted_money*coef_b)) or (my_money - betted_money))
  network.async(function () save_money() end)
  
  return this
end

function update_display_results(dt)
  if moving then
    if y_anim > 4 - (step-1)*sh then
      y_anim = max(y_anim - dt * 630, - (step-1)*sh)
    else
      y_anim = -(step-1)*sh
      moving = false
      sugar.audio.sfx ("selected")
    end
  end
end

function draw_display_results()
  cls(background_clr)
  
  for index = 1, #bets do
    
    local t_question  = bets[index].question
    local t_betted_on = bets[index].betted_on
    local t_result    = bets[index].t_result
    local t_achieved  = bets[index].achieved
    
    local y_offset = (index-1) * sh
    
    very_cool_print(t_question , sw/2,  80 + y_anim + y_offset)
    y_offset = y_offset + str_px_height("9")
    
    very_cool_print("Bet on :", sw/2, 180 + y_anim + y_offset, 0, 7, 5, 11)
    y_offset = y_offset + str_px_height("9")    
    very_cool_print(t_betted_on, sw/2, 180 + y_anim + y_offset, 0, 7)
    y_offset = y_offset + str_px_height("9")*2
   
    local it = t_betted_on == t_result
   
    very_cool_print("Result :", sw/2, 180 + y_anim + y_offset, 0, 7, 5, 11)
    y_offset = y_offset + str_px_height("9")    
    
    very_cool_print(t_result   , sw/2, 180 + y_anim + y_offset, 0, 7, (it and 13 or 3), 5)
    y_offset = y_offset + str_px_height("9")
    
  end
  
  local n_str = " > > "
  local x1 = sw - str_px_width(n_str)/2 -5
  local y1 = sh * 2/3 + 5 + sin_buttons
  local x2 = x1 + str_px_width(n_str)-5
  local y2 = y1 + str_px_height(n_str)+5
  
  color(10)
  rectfill(x1, y1, x2, y2)
  if ((mouse_in_rect(x1, y1, x2, y2) and btnp(0)) or btnp(1) )and not TRANSIT then
    sugar.audio.sfx ("selected") 
    if step == (#bets + 1) then
      begin_transition_from_to(this,"choose_game")
    else
      color(0)
      step = min(step , #bets) + 1
      moving = true
    end
  else
    color(5)
  end
  
  rectfill(x1 + 5, y1 + 5, x2 - 5, y2 - 5)
  cool_print(n_str, x1 , y1 )
  
  -- last screen before menu
  
  local y_offset = (#bets) * sh 
  
  local coin = (betted_money>1 and " coins" or " coin")
  
  very_cool_print((won_bet and "You win !" or "You lose !") , sw/2, 80 + y_anim + y_offset, 0, nil,  (won_bet and 13 or 3), 5)

  y_offset = y_offset + str_px_height("9")*5
  
  very_cool_print("You bet ".. betted_money .. coin, sw/2, 40 + y_anim + y_offset, 0, 5)  
  
  y_offset = y_offset + str_px_height("9")
  
  local th = (betted_money>1 and " them" or " it")

  very_cool_print((won_bet and "and now have ".. flr(betted_money*coef_b) .. " more" .. coin .. "!" or "and lost" .. th .. ".") , sw/2, 40 + y_anim + y_offset, 0, 5,  (won_bet and 13 or 3), 5)
  
  
  
end






















