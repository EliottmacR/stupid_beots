require("game")  -- where all the fun happens
require("random_functions")
require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

GW = 1000
GH = 600
zoom = 1

muted = false

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

  -- 3 orange
  -- 4 yellow
  -- 5 white
  -- 12 green
  -- 9 purple
  -- 10 blue
  -- 11 light blue
  -- 14 other blue
  -- 15 dark blue
  -- 12 other green

  -- ff8426 orange
  -- ffd100 yellow
  -- fafdff white
  -- bfff3c green
  -- 430067 purple
  -- 234975 blue
  -- 68aed4 light blue
  -- 007899 other blue
  -- 002859 dark blue
  -- 10d275 other green
  
  
  set_frame_waiting(30)
  
  love.math.setRandomSeed(os.time())
  load_sfx ("selected.wav", "selected", .5)
  load_sfx ("selected.wav", "lselected", .15)
  load_sfx ("selection.wav", "selection", .5)
  load_sfx ("selection.wav", "lselection", .15)
  load_sfx ("explosion.wav", "explosion", .4)
  load_sfx ("explosion2.wav", "explosion2", .4)
  
  load_music("background.wav", "bgm", 1)
  music("bgm", true)
  
  load_png("horse", "horse.png")
  
  load_png("sound", "sound.png")
  load_png("no_sound", "no_sound.png")
  
  load_png("help", "help.png")
  
  init_game()
end

function love.update(dt)
  update_game(dt)
end


function love.draw()
  draw_game()
end















