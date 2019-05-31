
function rock_paper_scissors(names)
    
  function q_a()
  
    local q = {}
    local a = {}
    local coefs = {}
    local BOT1, BOT2 = names[1] or "Botanicus", names[2] or "BimBamBot"
    
    table.insert(q,"Who will win out of the 20 tosses ?")
    table.insert(a,{BOT1, BOT2})
    table.insert(coefs,2.5)
    
    table.insert(q,"Who will win the first Coin toss ?")
    table.insert(a,{BOT1, BOT2})
    table.insert(coefs,2.5)
    
    table.insert(q,"Who will win the last Coin toss ?")
    table.insert(a,{BOT1, BOT2})
    table.insert(coefs,2.5)
    
    -- table.insert(q,"Who will win the first time ?")
    -- table.insert(a,{BOT1, BOT2})
    -- table.insert(coefs,2.5)
    
    -- table.insert(q,"Who will win the last time ?")
    -- table.insert(a,{BOT1, BOT2})
    -- table.insert(coefs,2.5)
  
    return q, a, coefs
  
  end
  
  local questions, answers, coefs = q_a()
  
  return 
  {
    name = "Jan Ken Pon!",
    description = {
                    -- "Not much more to add to the game ",
                    -- "title. A coin is flipped, you ",
                    -- "have 50 % chance of winning.",
                    -- "Do your best."
                    "Three choices, 50 rounds. ",
                    "The Botest shall win. "
                    },
    q = questions,
    a = answers,
    coefs = coefs
    
  }
  
end

function update_rock_paper_scissors(dt)

end

function draw_rock_paper_scissors()

end