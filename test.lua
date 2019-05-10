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
  local i2c = periphery.I2C('/dev/i2c-1')
  adxl345.enableMeasurement(i2c)
  local x,y,z = adxl345.readAcceleration(i2c)
  print('**', x, y, z)
  assertEquals(true, x ~= 0)
  assertEquals(true, y ~= 0)
  assertEquals(true, z ~= 0)
end)

it('readUShort', function()
  local msb, lsb = 109, 231
  assertEquals(28135, adxl345.readUShort(lsb, msb))
end) 

it('readShort', function()
  local msb, lsb = 215, 84
  assertEquals(-10412, adxl345.readShort(lsb, msb))
end) 
