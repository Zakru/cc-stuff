local tracked = require "trackedAsync"

function dig()
  local s, e

  while true do
    for x=0,7 do
      local zs, ze, zstep = 0, 7, 1
      if x % 2 == 1 then
        zs, ze, zstep = 7, 0, -1
      end
      for z=zs, ze, zstep do
        tracked.moveTo(x, 0, z)

        local b, l = turtle.inspectDown()
        if b then
          s, e = turtle.digDown()
          if not s then
            coroutine.yield("$turtle_error", "dig", e)
          end
        end
        coroutine.yield("$quarry", "block_done")
      end
    end

    s, e = turtle.down()
    if not s then
      coroutine.yield("$turtle_error", "move", e)
    end
  end

  return true, nil
end

function waitForEnter()
  print("Resolve the issue and press enter to continue")
  repeat
    local e, key, echo = os.pullEvent("key")
  until key == keys.enter
end

local digcoro = coroutine.create(dig)

while coroutine.status(digcoro) ~= "dead" do
  local result = {coroutine.resume(digcoro)}
  local status = result[1]
  
  while status and result[2] ~= nil and not result[2]:match("^%$") do
    result = {coroutine.resume(digcoro, coroutine.yield(result[2]))}
    status = result[1]
  end
  
  if status then
    local event = result[2]
    if event == "$tracked_error" then
      print(("tracked movement error: %s: %s"):format(result[3], result[4]))
      waitForEnter()
    elseif event == "$turtle_error" then
      print(("turtle error: %s: %s"):format(result[3], result[4]))
      waitForEnter()
    elseif event == "$quarry" and result[3] == "block_done" then
      print("block done")
    end
  else
    error("encoutered an error: " .. result[2])
  end
end
