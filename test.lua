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

it('setBandwidthRate', function()
  local i2c = periphery.I2C('/dev/i2c-1')
  adxl345.enableMeasurement(i2c)
  adxl345.setRange(i2c, adxl345.Range['2_G'])
  for _,bandwidthRateFlag in pairs(adxl345.BandwidthRate) do
    adxl345.setBandwidthRate(i2c, bandwidthRateFlag)
    local x,y,z = adxl345.readAcceleration(i2c)
    assertEquals(true, -2 <= x and x <= 2)
    assertEquals(true, -2 <= y and y <= 2)
    assertEquals(true, -2 <= z and z <= 2)
  end
end)

it('setRange', function()
  local i2c = periphery.I2C('/dev/i2c-1')
  adxl345.enableMeasurement(i2c)
  
  adxl345.setRange(i2c, adxl345.Range['2_G'])
  local x,y,z = adxl345.readAcceleration(i2c)
  assertEquals(true, -2 <= x and x <= 2)
  assertEquals(true, -2 <= y and y <= 2)
  assertEquals(true, -2 <= z and z <= 2)
  
  adxl345.setRange(i2c, adxl345.Range['4_G'])
  local x,y,z = adxl345.readAcceleration(i2c)
  assertEquals(true, -4 <= x and x <= 4)
  assertEquals(true, -4 <= y and y <= 4)
  assertEquals(true, -4 <= z and z <= 4)
  
  adxl345.setRange(i2c, adxl345.Range['8_G'])
  local x,y,z = adxl345.readAcceleration(i2c)
  assertEquals(true, -8 <= x and x <= 8)
  assertEquals(true, -8 <= y and y <= 8)
  assertEquals(true, -8 <= z and z <= 8)
  
  adxl345.setRange(i2c, adxl345.Range['16_G'])
  local x,y,z = adxl345.readAcceleration(i2c)
  assertEquals(true, -16 <= x and x <= 16)
  assertEquals(true, -16 <= y and y <= 16)
  assertEquals(true, -16 <= z and z <= 16)
end)
