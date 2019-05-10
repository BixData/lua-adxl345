print('Begin test')

local adxl345 = require 'adxl345'
local periphery = require 'periphery'

-- ============================================================================
-- Mini test framework
-- ============================================================================

local failures = 0

local function assertEquals(expected,actual,message)
  message = message or string.format('Expected %s but got %s', tostring(expected), tostring(actual))
  assert(actual==expected, message)
end

local function it(message, testFn)
  local status, err =  pcall(testFn)
  if status then
    print(string.format('✓ %s', message))
  else
    print(string.format('✖ %s', message))
    print(string.format('  FAILED: %s', err))
    failures = failures + 1
  end
end


-- ============================================================================
-- adxl345 module
-- ============================================================================

it('readAcceleration', function()
  local I2C = periphery.I2C
  local i2c = I2C('/dev/i2c-1')
  local x,y,z = adxl345.readAcceleration(i2c)
  print('**', x, y, z)
end)

it('readUShort', function()
  local msb, lsb = 109, 231
  assertEquals(28135, adxl345.readUShort(lsb, msb))
end) 

it('readShort', function()
  local msb, lsb = 215, 84
  assertEquals(-10412, adxl345.readShort(lsb, msb))
end) 
