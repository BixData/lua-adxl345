local bit32 = require 'bit32'
local I2C = require 'periphery'.I2C

local M = {
  ConversionFactor = {
    SCALE_MULTIPLIER = 0.004,
    STANDARD_GRAVITY = 9.80665
  },
  DataRate = {
    ['3200_HZ'] = 0x1111,
    ['1600_HZ'] = 0x1110,
    [ '800_HZ'] = 0x1101,
    [ '400_HZ'] = 0x1100,
    [ '200_HZ'] = 0x1011,
    [ '100_HZ'] = 0x1010,
    [  '50_HZ'] = 0x1001,
    [  '25_HZ'] = 0x1000,
    ['12_5_HZ'] = 0x0111,
    ['6_25_HZ'] = 0x0110,
    ['3_13_HZ'] = 0x0101,
    ['1_56_HZ'] = 0x0100,
    ['0_78_HZ'] = 0x0011,
    ['0_39_HZ'] = 0x0010,
    ['0_20_HZ'] = 0x0001,
    ['0_10_HZ'] = 0x0000
  },
  DEVICE = 0x53,
  MemoryMap = {
    REG_DATAX0 = 0x32
  },
  Range = {
    ['16_G'] = 0x11,
    [ '8_G'] = 0x10,
    [ '4_G'] = 0x01,
    [ '2_G'] = 0x00
  }
}

function M.readAcceleration(i2c)
  local msgs = {{M.MemoryMap.REG_DATAX0}, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, flags=I2C.I2C_M_RD}}
  i2c:transfer(M.DEVICE, msgs)
  local data = msgs[2]
  local x = M.readShort(data[1], data[2]) * M.ConversionFactor.SCALE_MULTIPLIER
  local y = M.readShort(data[3], data[4]) * M.ConversionFactor.SCALE_MULTIPLIER
  local z = M.readShort(data[5], data[6]) * M.ConversionFactor.SCALE_MULTIPLIER
  return x, y, z
end

function M.readShort(lsb, msb)
  local val = lsb + msb * 256
  if val >= 32768 then val = val - 65536 end
  return val
end

function M.readUShort(lsb, msb)
  return lsb + msb * 256
end

return M
