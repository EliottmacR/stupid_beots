require("game")  -- where all the fun happens
require("random_functions")
require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

if CASTLE_PREFETCH then
  CASTLE_PREFETCH({
    "assets/background.wav",
    "assets/explosion.wav",
    "assets/explosion2.wav",
    "assets/launch.wav",
    "assets/selected.wav",
    "assets/selection.wav",
    
    "assets/help.png",
    "assets/hors.png",
    "assets/sound.png",
    "assets/no_sound.png",
    
    "SB_games/_SB_games.lua",
    "SB_games/coin_toss.lua",
    "SB_games/janken.lua",
    "SB_games/horse_race.lua",
    
    "screens/_screen_controller.lua",
    "screens/background.lua",
    "screens/choose_bets.lua",
    "screens/choose_game.lua",
    "screens/display_results.lua",
    "screens/generic_screen.lua",
    "screens/main_menu.lua",
    "screens/sb_game.lua",
    "screens/shop.lua",
    "screens/title_screen.lua",
    "screens/winground.lua",
    
    "game.lua",
    "main.lua",
    "random_functions.lua"
    
})
end

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
  load_sfx ("assets/selected.wav", "selected", .5)
  load_sfx ("assets/selected.wav", "lselected", .15)
  load_sfx ("assets/selection.wav", "selection", .5)
  load_sfx ("assets/selection.wav", "lselection", .15)
  load_sfx ("assets/explosion.wav", "explosion", .4)
  load_sfx ("assets/explosion2.wav", "explosion2", .4)
  load_sfx ("assets/launch.wav", "launch", .2)
  
  load_music("assets/background.wav", "bgm", 1)
  music("bgm", true)
  
  load_png("horse", "assets/horse.png")  
  load_png("sound", "assets/sound.png")
  load_png("no_sound", "assets/no_sound.png")  
  load_png("help", "assets/help.png")
  
  init_game()
end

function love.update(dt)
  update_game(dt)
end


function love.draw()
  draw_game()
end















