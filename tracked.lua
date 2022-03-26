local tracked = {}

tracked.dir = 0
tracked.x = 0
tracked.y = 0
tracked.z = 0

function tracked.forward()
  local s, e = turtle.forward()
  if s then
    if tracked.dir == 0 then
      tracked.x = tracked.x + 1
    elseif tracked.dir == 1 then
      tracked.z = tracked.z - 1
    elseif tracked.dir == 2 then
      tracked.x = tracked.x - 1
    elseif tracked.dir == 3 then
      tracked.z = tracked.z + 1
    end
  end

  return s, e
end

function tracked.back()
  local s, e = turtle.back()
  if s then
    if tracked.dir == 0 then
      tracked.x = tracked.x - 1
    elseif tracked.dir == 1 then
      tracked.z = tracked.z + 1
    elseif tracked.dir == 2 then
      tracked.x = tracked.x + 1
    elseif tracked.dir == 3 then
      tracked.z = tracked.z - 1
    end
  end

  return s, e
end

function tracked.up()
  local s, e = turtle.up()
  if s then
    tracked.y = tracked.y + 1
  end

  return s, e
end

function tracked.down()
  local s, e = turtle.down()
  if s then
    tracked.y = tracked.y - 1
  end

  return s, e
end

function tracked.turnLeft()
  local s, e = turtle.turnLeft()
  if s then
    tracked.dir = (tracked.dir + 1) % 4
  end

  return s, e
end

function tracked.turnRight()
  local s, e = turtle.turnRight()
  if s then
    tracked.dir = (tracked.dir + 3) % 4
  end

  return s, e
end

function tracked.face(dir)
  local d = (dir - tracked.dir + 5) % 4 - 1
 
  if d > 0 then
    for i=1,d do
      local s, e = tracked.turnLeft()
      if not s then
        return s, e
      end
    end
  elseif d < 0 then
    for i=1,-d do
      local s, e = tracked.turnRight()
      if not s then
        return s, e
      end
    end
  end
  
  return true, nil
end

local function moveFacing(dir, d)
  local s, e

  if d > 0 then
    s, e = tracked.face(dir)
    if not s then
      return s, e
    end

    for i=1,d do
      s, e = tracked.forward()
      if not s then
        return s, e
      end
    end
  elseif d < 0 then
    s, e = tracked.face((dir + 2) % 4)
    if not s then
      return s, e
    end

    for i=1,-d do
      s, e = tracked.forward()
      if not s then
        return s, e
      end
    end
  end
  
  return true, nil
end

function tracked.moveTo(x, y, z)
  local dx, dy, dz = x - tracked.x, y - tracked.y, z - tracked.z
  local s, e

  s, e = moveFacing(0, dx)
  if not s then
    return s, e
  end

  s, e = moveFacing(3, dz)
  if not s then
    return s, e
  end
 
  if dy > 0 then
    for i=1,dy do
      s, e = tracked.up()
      if not s then
        return s, e
      end
    end
  elseif dy < 0 then
    for i=1,-dy do
      s, e = tracked.down()
      if not s then
        return s, e
      end
    end
  end
  
  return true, nil
end

function tracked.getPos()
  return tracked.x, tracked.y, tracked.z
end

return tracked

