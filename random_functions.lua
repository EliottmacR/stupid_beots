function very_cool_print(str, x, y, hspd, vspd)
  if not str or not x or not y then return end
  
  local w = str_px_width(str)
  local h = str_px_height(str)
  local x = x - w / 2
  local hspd = hspd or 15 
  local vspd = vspd or 15
  
  
  for i = 1, #str do
    local c = str:sub(i,i)
    cool_print(c, x + w *(i-1)/#str+ cos(i / #str + t() / 2) * hspd + 10, y + sin(i / #str + t() / 2) * vspd - h/2 + 10, 0, 0)
    cool_print(c, x + w *(i-1)/#str+ cos(i / #str + t() / 2) * hspd     , y + sin(i / #str + t() / 2) * vspd - h/2)
  end

end

function lesser_cool_print(str, x, y,spd)
  if not str or not x or not y then return end
  
  local w = str_px_width(str)
  local h = str_px_height(str)
  local x = x - w / 2
  local spd = spd or 7
  
  for i = 1, #str do
    local c = str:sub(i,i)
    cool_print(c, x + w *(i-1)/#str , y + sin(i / #str + t() / 2) * spd + 10 - h/2, 0, 0)
    cool_print(c, x + w *(i-1)/#str , y + sin(i / #str + t() / 2) * spd - h/2)
  end

end

function cool_print(str, x, y, inner_col, outer_col)
  if not str or not x or not y then return end
  
  local inner_col = inner_col or 1
  local outer_col = outer_col or 5
  local margin = 2
  color(inner_col)
  
  print(str, x-margin, y-margin)
  print(str, x-margin, y)
  print(str, x-margin, y+margin)
  
  print(str, x+margin, y-margin)
  print(str, x+margin, y)
  print(str, x+margin, y+margin)
  
  print(str, x, y-margin)
  print(str, x, y+margin)
  
  color(outer_col)
  print(str, x, y)

end

function count(tab)
  if not tab then return end
  local nb = 0
  for i, j in pairs(tab) do nb = nb + 1 end
  return nb
  
end

function str_px_height(str)
  if not str then return end
  return m_font:getHeight("str")
end

function draw_button(rect)
  if not rect.str then return end
  
  local c = cos(t() / 4) * 10
  local s = sin(t() / 2) * 10
  
  local xb1 = rect.x1 + c
  local yb1 = rect.y1 + s
  local xb2 = rect.x2 + c
  local yb2 = rect.y2 + s
  
  local border = rect.border
  
  local inner_col = rect.hovered and 12 or 2
  local outer_col = 11
  
  rectfill (xb1, yb1, xb2, yb2, outer_col)
  rectfill (xb1 + border, yb1 + border, xb2 - border, yb2 - border, inner_col)
  
  lesser_cool_print(rect.str, rect.xt , rect.yt + str_px_height(rect.str)/2)
end

function mouse_in_rect_screen(this, x1, y1, x2, y2)
  return mouse_in_rect(x1 + this.x, y1 + this.y, x2 + this.x, y2 + this.y)
end

function mouse_in_rect( x1, y1, x2, y2)
  if not x1 or not y1 or not x2 or not y2 then return end
  local mx = btnv(2)
  local my = btnv(3)
  return mx > x1 and mx < x2 and my > y1 and my < y2
end