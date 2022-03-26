local tracked = {}

tracked.dir = 0
tracked.x = 0
tracked.y = 0
tracked.z = 0

function tracked.forward()
  repeat
    local s, e = turtle.forward()
    if not s then
      coroutine.yield("$tracked_error", "move", e)
    end
  until s

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

function tracked.back()
  repeat
    local s, e = turtle.back()
    if not s then
      coroutine.yield("$tracked_error", "move", e)
    end
  until s

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

function tracked.up()
  repeat
    local s, e = turtle.up()
    if not s then
      coroutine.yield("$tracked_error", "move", e)
    end
  until s

  tracked.y = tracked.y + 1
end

function tracked.down()
  repeat
    local s, e = turtle.down()
    if not s then
      coroutine.yield("$tracked_error", "move", e)
    end
  until s

  tracked.y = tracked.y - 1
end

function tracked.turnLeft()
  repeat
    local s, e = turtle.turnLeft()
    if not s then
      coroutine.yield("$tracked_error", "turn", e)
    end
  until s
 
  tracked.dir = (tracked.dir + 1) % 4
end

function tracked.turnRight()
  repeat
    local s, e = turtle.turnRight()
    if not s then
      coroutine.yield("$tracked_error", "turn", e)
    end
  until s
 
  tracked.dir = (tracked.dir + 3) % 4
end

function tracked.face(dir)
  local d = (dir - tracked.dir + 5) % 4 - 1
 
  if d > 0 then
    for i=1,d do
      tracked.turnLeft()
    end
  elseif d < 0 then
    for i=1,-d do
      tracked.turnRight()
    end
  end
end

local function moveFacing(dir, d)
  if d > 0 then
    tracked.face(dir)

    for i=1,d do
      tracked.forward()
    end
  elseif d < 0 then
    tracked.face((dir + 2) % 4)

    for i=1,-d do
      tracked.forward()
    end
  end
end

function tracked.moveTo(x, y, z)
  local dx, dy, dz = x - tracked.x, y - tracked.y, z - tracked.z

  moveFacing(0, dx)

  moveFacing(3, dz)
 
  if dy > 0 then
    for i=1,dy do
      tracked.up()
    end
  elseif dy < 0 then
    for i=1,-dy do
      tracked.down()
    end
  end
end

function tracked.getPos()
  return tracked.x, tracked.y, tracked.z
end

return tracked

