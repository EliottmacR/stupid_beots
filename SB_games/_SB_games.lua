
require("SB_games/50_50")
require("SB_games/500_500")
require("SB_games/5000_5000")
require("SB_games/50000_50000")

SB_games = {}

current_game = nil

function init_SB_games()
  castle_print("called init_SB_games")
  
  for i = 1, 15 do
    table.insert(SB_games, _50_50())
    SB_games[i].name = "game nb " .. i  
    SB_games[i].desc = "this is the game nb " .. i .. " i hope you like it" 
  end  
    
    
  -- table.insert(SB_games, _5000_5000())
  -- table.insert(SB_games, _500_500())
  -- table.insert(SB_games, _50000_50000())
  -- table.insert(SB_games, _50_50())
  -- table.insert(SB_games, _5000_5000())
  -- table.insert(SB_games, _500_500())
  -- table.insert(SB_games, _50000_50000())
  -- table.insert(SB_games, _50_50())
  -- table.insert(SB_games, _5000_5000())
  -- table.insert(SB_games, _500_500())
  
  
end

function update_SB_game(dt)

end

function draw_SB_game()

end