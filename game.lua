
require("screens/_screen_controller")
require("SB_games/_SB_games")
-- color 11 and 12 look nice
-- color 7, 8, 9, 0 and 10 do not break your eyes
local background_clr = 4

function init_game()

  load_font("sugarcoat/TeapotPro.ttf", 64, "big", true)
  m_font = love.graphics.newFont("sugarcoat/TeapotPro.ttf", 64)
  
  init_screens()
  init_SB_games()
  register_btn(0, 0, input_id("mouse_button", "lb"))
  register_btn(1, 0, input_id("mouse_button", "rb"))
  register_btn(2, 0, input_id("mouse_position", "x"))
  register_btn(3, 0, input_id("mouse_position", "y"))
  register_btn(4, 0, input_id("mouse_button", "scroll_y"))
end

function update_game(dt)
  update_screens(dt)
end

function draw_game()
  cls(background_clr)
  draw_screens()
end
