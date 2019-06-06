
require("screens/_screen_controller")
require("SB_games/_SB_games")

-- color 11 and 12 look nice
-- color 7, 8, 9, 0 and 10 do not break your eyes

local background_clr = 4
my_money = nil
loaded_money = false
first_connection = true
time_since_launch = 0
-- local times_gave_money = 0
sin_buttons = 0



function init_game()

  load_font("sugarcoat/TeapotPro.ttf", 32, "description", false)
  load_font("sugarcoat/TeapotPro.ttf", 64, "big", true)
  load_font("sugarcoat/TeapotPro.ttf", 76, "very_big", false)
  load_font("sugarcoat/TeapotPro.ttf", 126, "very_very_big", false)
  m_font = love.graphics.newFont("sugarcoat/TeapotPro.ttf", 64)
  
  if not loaded_money then
    network.async(function () 
      my_money = castle.storage.get("money")
      if my_money then first_connection = false end
      
      my_money = my_money or 3
      loaded_money = true
    end)
  end
  init_screens()
  init_SB_games()
  register_btn(0, 0, input_id("mouse_button", "lb"))
  register_btn(1, 0, input_id("mouse_button", "rb"))
  register_btn(2, 0, input_id("mouse_position", "x"))
  register_btn(3, 0, input_id("mouse_position", "y"))
  register_btn(4, 0, input_id("mouse_button", "scroll_y"))
  register_btn(5, 0, input_id("keyboard", "tab"))
  register_btn(6, 0, input_id("keyboard", "return"))
  
  love.mouse.setVisible(false)
end
  

function update_game(dt)
  time_since_launch = time_since_launch + dt
  sin_buttons = sin(t() / 2) * 5
  update_screens(dt)
end

function draw_game()
  cls(background_clr)
  draw_screens()
  draw_mouse()
end


function draw_mouse()
  
  circfill(btnv(2), btnv(3), 8, 0)
  
  rectfill(btnv(2) - 4, btnv(3) - 2,btnv(2) + 4, btnv(3) + 2, flr(time_since_launch*5)%16)
  rectfill(btnv(2) - 2, btnv(3) - 4,btnv(2) + 2, btnv(3) + 4, flr(time_since_launch*5)%16)
  
end

function save_money()
  castle.storage.set("money", my_money)
end

function load_money()
  log(castle.storage.get("money"))
end

function erase_money()
  castle.storage.set("money", nil)
end