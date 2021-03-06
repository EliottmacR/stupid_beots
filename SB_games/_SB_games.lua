
require("SB_games/coin_toss")
require("SB_games/janken")
require("SB_games/horse_race")

SB_games = {}

current_game = nil

_bot_names = {"Botanicus", "BimBamBot", "RockBotTom", "Boteul-Flip", "Bo.a.t", "MoreIsBoter", "Botista", "Botnashyal", "Trasevol-Bot", "BenjaminBoton", "BotBourbon", "Botar-System", "FireBot", "Botman", "Botderlander", "BotsMayCry", "PoketBot", "Botco-8", "Botemonogatari", "Angel Bot", "BotStation"}

function init_SB_games()
  castle_print("called init_SB_games")
  
  table.insert(SB_games, coin_toss(rnd_names_for_bots(2)))
  table.insert(SB_games, janken(rnd_names_for_bots(2)))
  table.insert(SB_games, horse_race(rnd_names_for_bots(2)))
    
end

function update_SB_game(dt)


end

function draw_SB_game()

end

function rnd_names_for_bots( number )
  names = {}
  
  for i = 1, number do
    local name = pick(_bot_names)
    
    while check_in(name, names) do 
      name = pick(_bot_names)
    end
    names[i] = name
  end
  
  return names
end


function check_in(value, tab)
  for index, val in pairs(tab) do
    if val == value then return true end
  end
  return false
end









