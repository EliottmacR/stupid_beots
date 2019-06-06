
local background_clr = 2
local this
local sw
local sh

local choosen_game = nil

local y_tab = 150
local clicked_on = {}

coef_b = 1
betted_money = 1


function init_choose_bets(z)
  sw = GW
  sh = GH
  z = z or 1
  this = init_screen("choose_bets",update_choose_bets, draw_choose_bets, background_clr, 0, 0, sw, sh, z )
  
  choosen_game = selected_game
  choosen_game = SB_games[selected_index or 1]
  y_tab = 150
  coef_b = 1
  dt_minus = 0
  dt_plus = 0
  clicked_on = {}
  clicked_on_bet = false
  betted_money = 1
  
  pre_pox_x = 0
  pre_pox_y = 0
  
  -- log(choosen_game.name)
  return this
end

function update_choose_bets(dt)
  if not choosen_game.q then return end
  
  if btnp(1) and not TRANSIT then 
    begin_transition_from_to(this,"choose_game")
  end
    
  if btn(4) and not TRANSIT then
    y_tab = y_tab + ((btnv(4) > 0) and 40 or -40  )
    
    if y_tab >= sin_buttons + 150 then y_tab = sin_buttons + 150 end
    if y_tab <= - max_y then 
      y_tab = - max_y  
    end
  end
  
end

local pre_pox_x
local pre_pox_y

function draw_choose_bets()
  if not choosen_game.q then return end
  cls(background_clr)
  
  -- each question has a tab of answers
  -- for each question, we'll write the question and below, the answers.
  
  -- all the questions will be on the same page and the enter button will fetch from the interface a list of booleen that will, at the end of the game,
  -- be compared to the results of that game
  
  for iq = 1, #choosen_game.q do -- iq : index question
  
    local q = choosen_game.q[iq]
    cool_print(q, 10 + 5, iq * str_px_height("9") * 3 + y_tab + sin_buttons + 5, 0, 0) 
    cool_print(q, 10    , iq * str_px_height("9") * 3 + y_tab + sin_buttons) 
    
    cumulated_w = 0
    local as = choosen_game.a[iq]
    for ia = 1, #as do -- ia : index answer
      local a = as[ia]
      --answer_in_button
        local xb,yb, wb, hb, border
        xb = 10 + cumulated_w
        yb = iq * str_px_height("9") * 3 + str_px_height("9") + 10 + y_tab + sin_buttons
        wb  = 15 + str_px_width(a) + 15
        hb  = str_px_height("9") 
        border = 8
        
        local hovered = false
        if not TRANSIT then
          if mouse_in_rect(xb, yb, xb + wb, yb + hb) then
            if not mouse_in_rect(xb, yb, xb + wb, yb + hb, pre_pox_x, pre_pox_y) then 
              sugar.audio.sfx ("selected")
              -- log("here")
            end
            hovered = true
          elseif clicked_on[iq*10 + ia] then
            hovered = true
          end
        end
        
        if not TRANSIT and btnp(0) and mouse_in_rect(xb, yb, xb + wb, yb + hb) then 
          hovered = not hovered click_on_answer(iq, ia)
          sugar.audio.sfx ("selection")  
        end
        
        button (a, xb, yb, wb, hb, border, hovered, nil, nil, nil, clicked_on[iq*10 + ia])
    
      cumulated_w = cumulated_w + str_px_width(a) + 40 
      max_y = yb + hb - border - sin_buttons - y_tab - sh*4/5
      
    end
  end
  if coef_b ~= 1 then
    local xb,yb, wb, hb, border
    xb = 10
    yb = (#choosen_game.q+1) * str_px_height("9") * 3 + str_px_height("9") + y_tab + sin_buttons
    wb  = 15 + str_px_width(" Bet! ") + 15
    hb  = str_px_height("9")
    border = 8
    
    local hovered = false
    
    
    hovered = mouse_in_rect(xb, yb, xb + wb, yb + hb)  
    if mouse_in_rect(xb, yb, xb + wb, yb + hb) then
      if not mouse_in_rect(xb, yb, xb + wb, yb + hb, pre_pox_x, pre_pox_y) then 
        sugar.audio.sfx ("selected") 
      end
      if not TRANSIT and not clicked_on_bet and (btnp(0) or btnp(6)) then 
        hovered = true
        click_on_bet() 
        sugar.audio.sfx ("selection") 
      end
    end
    
    button (" Bet! ", xb, yb, wb, hb, border, hovered, 11, 5)
    max_y = yb + hb - border - sin_buttons - y_tab - sh*4/5
  end
  

  local rect_size = 600
  local rect_size_w = 400
  local rect_size_h = 300
  local rx, ry = sw - rect_size_w , 0
  local border = 10
  local t = flr(time_since_launch % 3)
  local color_lines = t % 3 == 0 and 6 or t % 3 == 1 and 8 or 11 
  
  
  color(color_lines)
  rectfill(0, 0 , sw, 300)
  color(background_clr)
  rectfill(border, border, sw - border, 300 - border)
  
  -- bet
  --  x
  -- x x
  
  
  color(color_lines)
  rectfill(rx, ry, rx + rect_size_w, ry + rect_size_h)
  
  -----------
  
  color(background_clr)
  rectfill(rx + border              , ry + border                , rx + rect_size_w   - border, ry + rect_size_h/3 - border) 
  local bet_str = "Owned: " .. my_money .. (my_money > 1 and " cs" or " c")
  shaded_cool_print(bet_str, rx + rect_size_w/2  - str_px_width(bet_str)/2,ry + str_px_height(bet_str)/2 - 10 + sin_buttons)
  
  -----------
  
  color(background_clr)
  rectfill(rx + border              , ry + rect_size_h/3  , rx + rect_size_w   - border, ry + rect_size_h * 2/3 - border)
  
  local money_str = betted_money .. (betted_money > 1 and " cs" or " c")
  
  shaded_cool_print(money_str, rx + rect_size_w/2  - str_px_width(money_str)/2 ,ry + str_px_height(money_str)/2 - 10 + sin_buttons + rect_size_h/3)
  
  -----------
  
  if btnp(0) and mouse_in_rect(rx + border, ry + rect_size_h*2/3, rx + rect_size_w/2 - border/2, ry + rect_size_h - border) then
    betted_money = max(betted_money - 1, 1)
    dt_minus = dt_minus + dt()
    sugar.audio.sfx ("lselected") 
  end
  
  if dt_minus > 0 then
    dt_minus = dt_minus + dt()
    if dt_minus > .5 then
      betted_money = max(betted_money - flr((dt_minus + 1) * .8), 1)
      if betted_money ~= 1 then
      sugar.audio.sfx ("lselected") 
      end
    end
  end
  
  
  color(dt_minus ~= 0 and 5 or background_clr)
  rectfill( rx + border              , ry + rect_size_h*2/3, rx + rect_size_w/2 - border/2, ry + rect_size_h - border)
  
  local yy = rx + border + (rect_size_w/2 - border*1.5) * min((dt_minus > 0 and dt_minus or 0), .5) * 2
 
  if yy - (rx + border) > 5 then 
    rectfill( rx + border            , 
              ry + rect_size_h*2/3, 
              yy  ,
              ry + rect_size_h*2/3 + 20 - border, 13)
            
  end
            
            
            
            
            
  local minus =  "-" 
  shaded_cool_print(minus, rx + rect_size_w/4  - str_px_width(minus)/2 ,ry + str_px_height(minus)/2 - 10 + sin_buttons + rect_size_h*2/3)
  
  
  -----------
  
  if btnp(0) and mouse_in_rect(rx + border/2 + rect_size_w/2, ry + rect_size_h*2/3, rx + rect_size_w   - border, ry + rect_size_h - border) then     
    dt_plus = dt_plus + dt()
    betted_money = min(betted_money + 1, my_money)
    sugar.audio.sfx ("lselection") 
  end
  
  if dt_plus > 0 then
    dt_plus = dt_plus + dt()
    if dt_plus > .5 then
      betted_money = min(betted_money + flr((dt_plus + 1) * .8), my_money)
      if betted_money ~= my_money then
        sugar.audio.sfx ("lselection") 
      end
    end
  end
  
  
  if btnr(0) then
    dt_minus = 0
    dt_plus = 0
  end
  
  color(dt_plus ~= 0 and 5 or background_clr)
  rectfill(rx + border/2 + rect_size_w/2, ry + rect_size_h*2/3, rx + rect_size_w   - border, ry + rect_size_h - border)
  local plus = "+"
  shaded_cool_print(plus, rx + rect_size_w*3/4  - str_px_width(plus)/2 ,ry + str_px_height(plus)/2 - 10 + sin_buttons + rect_size_h*2/3)
  
  local yy = rx + border/2 + rect_size_w/2  + (rect_size_w/2  - border*1.5) * min((dt_plus > 0 and dt_plus or 0), .5) * 2
    
  if yy - (rx + border/2 + rect_size_w/2) > 5 then 
    rectfill( rx + border/2 + rect_size_w/2          , 
              ry + rect_size_h*2/3, 
              yy  ,
              ry + rect_size_h*2/3 + 20 - border, 13)
  end
  
  if coef_b > 1 then
    local str = " Possible gain: " .. flr(betted_money * coef_b) .. "c" .. (betted_money>1 and "s" or "")
    lesser_cool_print(str, (sw - rect_size_w)/2, rect_size_h/2-str_px_height(str)/2 , nil, 5,  10)
  else
  
    local str = " Choose at least"
    lesser_cool_print(str, (sw - rect_size_w)/2, rect_size_h/2-str_px_height(str)/2, nil, nil, 11)
    
    local str = " one bet bellow"
    lesser_cool_print(str, (sw - rect_size_w)/2, rect_size_h/2-str_px_height(str)*1/4 + str_px_height(str), nil, nil, 11)
    
  end
  
  if #choosen_game.q > 2 and y_tab > 130 then
    use_font("description")
    shaded_cool_print("Scroll to see more", cos(time_since_launch)*3 + sw - str_px_width("scroll to see more") - 7 ,sin(time_since_launch * 2) * 3 +  sh - str_px_height("scroll to see more")/2, flr(time_since_launch * 5) % 16 )
    use_font("big")
  end
  
  pre_pox_x = btnv(2)
  pre_pox_y = btnv(3)
  
end

function button (a, xb, yb, wb, hb, border, hovered, c1, c2, c3)
  c1 = c1 or 0
  c2 = c2 or background_clr
  c3 = c3 or 1
  hovered = hovered or false
  
  color(not hovered and c1 or 1)
  rectfill(xb, yb, xb+wb, yb+hb)
  color(c2)
  rectfill(xb + border, yb + border, xb+wb - border, yb+hb - border)
  
  local start_x = (wb - str_px_width(a))/2 
  local start_y = (hb - str_px_height(a))/2 - border  
  
  cool_print(a, xb + start_x + 5, yb + start_y + 5, 0, 0)
  cool_print(a, xb + start_x, yb + start_y)
end

function click_on_answer(iq, ia)
  clicked_on[iq*10 + ia] = not clicked_on[iq*10 + ia]
  for i = 0, 9 do
    if i ~= ia and clicked_on[iq*10 + i] then clicked_on[iq*10 + i] = false end
  end
  
  calculate_coef()
  
end

function calculate_coef()

  coef_b = 1
  
  for i, bet in pairs(clicked_on) do
    if bet then
      local q = flr(i/10)
      coef_b = coef_b * choosen_game.coefs[q]
    end
  end
  coef_b = flr((coef_b * 10)) / 10
end

function click_on_bet() 

  if coef_b > 1 then
    clicked_on_bet = true
    begin_transition_from_to(this,"sb_game")
    set_sb_game(choosen_game)
    set_sb_rules(clicked_on)
  end
end











