local tracked = require "tracked"

function dig()
  local s, e

  while true do
    for x=0,7 do
      local zs, ze, zstep = 0, 7, 1
      if x % 2 == 1 then
        zs, ze, zstep = 7, 0, -1
      end
      for z=zs, ze, zstep do
        repeat
          s, e = tracked.moveTo(x, 0, z)
          if not s then
            coroutine.yield(s, e)
          end
        until s

        local b, l = turtle.inspectDown()
        if b then
          s, e = turtle.digDown()
          if not s then
            coroutine.yield(s, e)
          end
        end
      end
    end
    s, e = turtle.down()
    if not s then
      coroutine.yield(s, e)
    end
  end

  return true, nil
end

local digcoro = coroutine.create(dig)

while coroutine.status(digcoro) ~= "dead" do
  local status, s, e = coroutine.resume(digcoro)
  
  while status and type(s) == "string" do
    status, s, e = coroutine.resume(digcoro, coroutine.yield(s))
  end
  
  if status then
    if not s then
      print("error while digging: " .. e)
      break
    end
  else
    error("encoutered an error: " .. s)
  end
  sleep(0.05)
end
