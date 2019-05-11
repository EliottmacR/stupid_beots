
local background_clr = 2
local this
local sw
local sh

local circles = {circles = {}, nmb = 20, m_size = 60, speed = 2}

function init_background(z)
  sw = GW
  sh = GH
  this = init_screen("background",update_background, draw_background, background_clr, 0, 0, sw, sh, z or 1 )
  
  for i = 1, circles.nmb do
    local circle = new_circle()
    circle.r = irnd(circles.m_size)
    table.insert(circles.circles, circle)
  end
  return this
end

function update_background()
  for i, c in pairs(circles.circles) do
    c.r = c.r + c.sign * c.speed
    if c.r > circles.m_size then c.sign = -1
    elseif c.r < 0  then circles.circles[i] = new_circle() end
  end
end

function draw_background()
  cls(background_clr)
  for i, c in pairs(circles.circles) do
    circfill(c.x, c.y + (c.st*2 - t()*2) * 70 , c.r + 4, c.clr == 0 and 6 or 0)
    circfill(c.x, c.y + (c.st*2 - t()*2) * 70 , c.r, c.clr)
  end
end

function new_circle()
  local clr = irnd(16)
  while(clr == background_clr) do
    clr = irnd(16)
  end
  
  return {
    x = irnd(GW) ,
    y = irnd(GH) + 140,
    st = t(),
    r = 0,
    sign = 1,
    speed = circles.speed/2 + rnd(speed),
    clr = clr}
end