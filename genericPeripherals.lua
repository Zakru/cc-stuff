local gp = {}

gp.peripherals = {}

local f = fs.open("/peripherals.conf", "r")

if f then
  while true do
    local line = f.readLine()
    if not line then break end
    
    local key, value = line:match("^%s*(%S+)%s*=%s*(%S+)%s*$")
    if not key then
      error("invalid line in peripheral configuration: " .. line)
    end
    
    gp.peripherals[key] = value
  end

  f.close()
end

function gp.getNames()
  local names = {}
  for k,v in pairs(gp.peripherals) do
    if peripheral.isPresent(v) then
      table.insert(names, k)
    end
  end
  return names
end

function gp.isPresent(name)
  return gp.peripherals[name] and peripheral.isPresent(gp.peripherals[name])
end

function gp.getType(periph)
  if type(periph) == "string" then
    periph = gp.peripherals[periph]
  end
  
  return peripheral.getType(periph)
end

function gp.hasType(periph, periph_type)
  if type(periph) == "string" then
    periph = gp.peripherals[periph]
  end
  
  return peripheral.hasType(periph, periph_type)
end

function gp.getMethods(name)
  return gp.peripherals[name] and peripheral.getMethods(gp.peripherals[name])
end

function gp.getName(periph)
  return getmetatable(periph).genericName
end

function gp.call(name, method, ...)
  return gp.peripherals[name] and peripheral.call(gp.peripherals[name], method, ...)
end

function gp.wrap(name)
  if not gp.isPresent(name) then return nil end
  local periph = peripheral.wrap(gp.peripherals[name])
  getmetatable(periph).genericName = name
  return periph
end

return gp
