-- this will play a mod file
-- run with love ./demo_love

local OpenMPT = require "../openmpt"

bitDepth = 16
samplingRate = 44100
channelCount = 2
bufferSize = 2048
pointer = 0

local mod = OpenMPT:new("./plainsong.xm")

function love.load()
  sd = love.sound.newSoundData(bufferSize, samplingRate, bitDepth, channelCount)
  qs = love.audio.newQueueableSource(samplingRate, bitDepth, channelCount)
end

function love.update(dt)
  if qs:getFreeBufferCount() == 0 then return end
  local samplesToMix = bufferSize
  mod:read_interleaved_stereo(samplingRate, bufferSize, sd:getFFIPointer())
  for smp = 0, samplesToMix-1 do
    pointer = pointer + 1
    if pointer >= sd:getSampleCount() then
      pointer = 0
      qs:queue(sd)
      qs:play()
    end
  end
end