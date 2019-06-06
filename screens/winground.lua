
local background_clr = 2
local this
local sw
local sh

display_back = false
wg_done = true

fireworks = {}

gravity = {x = 0, y = 1}

timer_beginning = 0
timer_respawn = 0


function init_winground(z)
  sw = GW
  sh = GH
  this = init_screen("winground",update_winground, draw_winground, background_clr, 0, 0, sw, sh, z or 1 )
  display_back = false
  
  fireworks = {}
  timer_beginning = 0
  timer_respawn   = -1
  
  wg_done = false
  log("created")
  
  return this
end

function create_firework(x, y)
  sugar.audio.sfx ("launch")
  table.insert(fireworks, {pos = {x = x, y = y} , vel = {x = 0, y = -35 + rnd(10) }, particles = {}, exploded = false, color = irnd(16) })
end


function update_winground(dt)

  timer_beginning = timer_beginning + dt

  if timer_beginning < 15 then  
    timer_respawn = timer_respawn   - dt    
    if timer_respawn < 0 then    
      create_firework(irnd(sw), sh)          
      timer_respawn = rnd(.8)      
    end    
  end


  if timer_beginning > 5 and count(fireworks) < 1 then
    remove_screen(this)
    wg_done = true
  end
  
  for indf, firework in pairs(fireworks) do
  
      if not firework.exploded then
        -- update velocity
        firework.vel.x = firework.vel.x + gravity.x
        firework.vel.y = firework.vel.y + gravity.y
        
        -- update position
        firework.pos.x = firework.pos.x + firework.vel.x
        firework.pos.y = firework.pos.y + firework.vel.y
        
        if firework.vel.y > 0 then 
          for i = 1, 100 do
            local angle = rnd(1)
            table.insert(firework.particles, {pos = {x = firework.pos.x, y = firework.pos.y} , 
                                              vel = {x = cos(angle) * irnd(15), y = sin(angle) * irnd(15) }, 
                                              -- vel = {x = cos(angle) * 3 , y = sin(angle) * 3 }, 
                                              life = 300,
                                              color = firework.color})
          end
          firework.exploded = true
          sugar.audio.sfx ("explosion")
          sugar.audio.sfx ("explosion2")
        end
      else
        if count(firework.particles) < 1 then 
          fireworks[indf] = nil 
        end
      end
  
    for indp, particle in pairs(firework.particles) do
      -- update velocity 
      if particle.life > 200 then 
        particle.vel.x = (particle.vel.x + gravity.x) * .99     
        particle.vel.y =  particle.vel.y + gravity.y/3
      else 
        particle.vel.x = particle.vel.x * .7 
        particle.vel.y = particle.vel.y * .7 + gravity.y/3
      end
      
      -- update position
      particle.pos.x = particle.pos.x + particle.vel.x
      particle.pos.y = particle.pos.y + particle.vel.y
      
      particle.life = particle.life - 300 * dt
      
      if particle.life < 0 then 
        firework.particles[indp] = nil 
      end
      
    end
    
  end
  
end

function draw_winground()
  cls(background_clr)
  
  for indf, firework in pairs(fireworks) do    
  
    if not firework.exploded then
      color(0)    
      circfill(firework.pos.x, firework.pos.y, 10)    
      color(firework.color)
      circfill(firework.pos.x, firework.pos.y, 9)    
    end
    for indp, particle in pairs(firework.particles) do   
      color(0)   
      circfill(particle.pos.x, particle.pos.y, 5 * particle.life / 300 + 1)  
      color(particle.color)         
      circfill(particle.pos.x, particle.pos.y, 5 * particle.life / 300)        
    end
  end
  
end