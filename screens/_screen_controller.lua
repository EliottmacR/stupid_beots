require("screens/background")
require("screens/title_screen")
require("screens/main_menu")
require("screens/generic_screen")

screen_controller = {layer = { {} } }
transitioning = {}
begin_t_time = nil

function init_screens()
  init_background(0)
  init_title_screen(1)
  -- init_main_menu(1)
end

function init_screen(name, update, draw, background_clr, x, y, w, h, z)
  if not update or not draw then return end
  
  local background_clr = background_clr or 2
  local w = w or GW
  local h = h or GH
  local x = x or 0
  local y = y or 0
  local z = z or 1
  
  local surface = new_surface(w, h)
  local screen = {
    x = x,
    y = y,
    z = z,
    name = name,
    background_clr = background_clr,
    
    surface = surface,
    update = update,
    draw = draw,
    
    values = {}
  }
  return add_screen(name, screen, z)

end

function update_screens(dt)

  if count(transitioning) > 1 then 
    local x = (t()-begin_t_time) / 2
    
    if transitioning[3] == "to_left" then
    
      local left_screen = transitioning[2]
      local right_screen = transitioning[1]
      
      if left_screen then
        left_screen.x = lerp(-GW, 0, x)
        if left_screen.x >= 0 then 
          left_screen.x = 0
          transitioning[2] = nil
        end
      end      
      if right_screen then
        right_screen.x = lerp(0, GW, x)
        if right_screen.x >= GW then 
          remove_screen(transitioning[1])
          transitioning[1] = nil
        end
      end
      
    else ------- to_right
    
      local left_screen = transitioning[1]
      local right_screen = transitioning[2]
    
      if left_screen then
        left_screen.x = lerp(0, -GW, x)
        if left_screen.x <= -GW then 
          left_screen.x = -GW 
          remove_screen(transitioning[1])
          transitioning[1] = nil
        end
      end
      
      if right_screen then
        right_screen.x = lerp(GW, 0, x)
        if right_screen.x <= 0 then 
          right_screen.x = 0 
          transitioning[2] = nil
        end
      end
    
    end
  end
  for i, layer in pairs(screen_controller.layer) do
    for j, screen in pairs(layer) do
      screen.update(dt)
    end  
  end  
end

function draw_screens()
  local mini = 100
  for i,l in pairs (screen_controller.layer) do if i < mini then mini = i end end 

  for z = mini, count(screen_controller.layer)-(1 - mini) do
    for j, screen in pairs(screen_controller.layer[z]) do
      if screen.surface then
        target(screen.surface)
        screen.draw()
        target()
        
        palt(screen.background_clr, true)
        spr_sheet(screen.surface, screen.x , screen.y)
        palt(screen.background_clr, false)
      end 
    end 
  end
end

-- surface key is key in screen_controller.layer[z]
function add_screen(name, screen, z)
  if not name or not screen then return end 
  if not screen_controller.layer[z] then screen_controller.layer[z] = {} end
  screen_controller.layer[z][screen.surface] = screen
  return screen_controller.layer[z][screen.surface]
end

function remove_screen(screenp)
  if not screenp then return end 
  
  for j, layer in pairs(screen_controller.layer) do
    for key, screen in pairs(layer) do
      if screen.surface == screenp.surface then
        delete_surface(screenp.surface)
        -- castle_print("deleted " ..screen.surface)
        screen_controller.layer[j][screen.surface] = nil 
      end
    end
  end
end

function get_tree_values()
  return {
    title_screen = 1,
    main_menu = 2
  }
end

function begin_transition_from_to(screen, name)
  if not screen then return end
  
  transitioning = {}
  local tree_values = get_tree_values()
  
  transitioning[1] = screen
  
  if name == "title_screen" then
    transitioning[2] = init_title_screen(screen.z)
  elseif name == "main_menu" then  
    transitioning[2] = init_main_menu(screen.z)   
  end
  
  transitioning[3] = (tree_values[screen.name] < tree_values[name]) and "to_right" or "to_left"
  
  transitioning[2].x = GW * (transitioning[3] == "to_left" and -1 or 1)
  begin_t_time = t()
end
