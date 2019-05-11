
local background_clr = 2
local this
local sw
local sh

function init_generic_screen(z)
  sw = GW
  sh = GH
  this = init_screen("generic_screen",update_generic_screen, draw_generic_screen, background_clr, 0, 0, sw, sh, z )
  return this
end

function update_generic_screen(dt)
  
end

function draw_generic_screen()
  cls(background_clr)
  lesser_cool_print("generic screen", sw/2 , sh/2)
end