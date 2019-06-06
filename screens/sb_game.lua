
local background_clr = 2
local this
local sw
local sh

--

sb_screen = nil
sb_game = nil
  local sb_game_update
  local sb_game_draw


sb_rules = nil

local time_

function init_sb_game(z)
  sw = GW
  sh = GH
  sb_screen = init_screen("sb_game",update_sb_game, draw_sb_game, background_clr, 0, 0, sw, sh, z )
  time_ = 0
  display_back = false
  inited = false
  sb_game = nil
  sb_rules = nil
  display_skip = true
  
  return sb_screen
end

function update_sb_game(dt)
  time_ = time_ + dt
  if time_ > 2 and not inited then init_() end
  
  sb_game_update(dt)
  
end

function draw_sb_game()
  cls(background_clr)
  if not inited then
    lesser_cool_print("Loading . . .", sw/2 , sh/2)
  end
  
  sb_game_draw()
   
  
end


function init_()
  inited = true
  sb_game.init(sw, sh, background_clr)
  sb_game_update = sb_game.update
  sb_game_draw = sb_game.draw

end






function set_sb_game(choosen_game)
  sb_game = choosen_game
  sb_game_update = function()end
  sb_game_draw = function()end
end

function  set_sb_rules(clicked_on)
  -- q = questions
  -- a = answers
  -- coefs = coefs
  -- b_names = b_names
  
  local rules = {}
  
  for ind, r in pairs(clicked_on) do
    if r then rules[ind] = true end
  end
  
  sb_rules = rules
  
  -- for index, rule in pairs(rules) do
    -- if rule then 
      -- local question = flr(index/10)
      -- local answer = index - question * 10
    
      -- log("what is bet on :" .. sb_game.q[question] .. " and who : " .. sb_game.a[question][answer])
    -- end
  -- end
  
end



-- function click_on_answer(iq, ia)

  -- clicked_on[iq*10 + ia] = not clicked_on[iq*10 + ia]
  -- for i = 0, 9 do
    -- if i ~= ia and clicked_on[iq*10 + i] then clicked_on[iq*10 + i] = false end
  -- end
  
  -- calculate_coef()
  
-- end







