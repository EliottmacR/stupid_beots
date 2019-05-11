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
-- 0x16171a, 0x7f0622, 0xd62411, 0xff8426,
-- 0xffd100, 0xfafdff, 0xff80a4, 0xff2674,
-- 0x94216a, 0x430067, 0x234975, 0x68aed4,
-- 0xbfff3c, 0x10d275, 0x007899, 0x002859
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

















