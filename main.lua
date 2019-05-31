require("game")  -- where all the fun happens
require("random_functions")
require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

GW = 1000
GH = 600
zoom = 1

function love.load()
  init_sugar("!Stupid Beots!", GW, GH, zoom )
  screen_render_integer_scale(false)
  use_palette(palettes.bubblegum16)
  palt(0, false)  
  
-- bubblegum16 = {
-- 16171a, 7f0622, d62411, ff8426,
-- ffd100, fafdff, ff80a4, ff2674,
-- 94216a, 430067, 234975, 68aed4,
-- bfff3c, 10d275, 007899, 002859
-- }
  
  
  
  set_frame_waiting(30)
  
  love.math.setRandomSeed(os.time())
  love.mouse.setVisible(true)
  
  init_game()
end

function love.update(dt)
  update_game(dt)
end


function love.draw()
  draw_game()
end

















