local versionInfo = "KISS Telemetry Data - alpha 0.0.1"

-- mahTarget is used to set our target mah consumption and mahAlertPerc is used for division of alerts
local mahTarget = 900
local mahAlertPerc = 10

local lastMahAlert = 0


----------------------------------------------------------------
-- Custom Functions
----------------------------------------------------------------
local function getTelemetryId(name)
 field = getFieldInfo(name)
 if getFieldInfo(name) then return field.id end
  return -1
end

local data = {}
  data.fuelUsed = getTelemetryId("Fuel")


-------------------------------------------------------------------------
-- Utilities
-------------------------------------------------------------------------
-- Rounding Function
local function round(val, decimal)
    local exp = decimal and 10^decimal or 1
    return math.ceil(val * exp - 0.5) / exp
end

--MahAlert and Logging of last Value Played
local function playMahPerc(percVal)
  playNumber(percVal,8)
  lastMahAlert = percVal  -- Set our lastMahAlert
end

local function playCritical(percVal)
  playFile("batcrit.wav")
  lastMahAlert = percVal  -- Set our lastMahAlert
end





local function playAlerts()

    percVal = 0
    curMah = getValue(data.fuelUsed)

    if curMah ~= 0 then
      percVal =  round(((curMah/mahTarget) * 100),0)

      if percVal ~= lastMahAlert then
        -- Alert the user we are in critical alert
        if percVal > 100 then
          playCritical(percVal)
        elseif percVal > 90 and percVal < 100 then
          playMahPerc(percVal)
        elseif percVal % mahAlertPerc == 0 then
          playMahPerc(percVal)
        end
      end
    end

end

local function drawAlerts()

  percVal = 0
  curMah = getValue(data.fuelUsed)
  percVal =  round(((curMah/mahTarget) * 100),0)

  -- lcd.drawGauge(6, 35, 70, 20, percVal, 100)

  lcd.drawText(5, 20, "USED: "..curMah.."mah" , MIDSIZE)
  lcd.drawText(90, 40, percVal.." %" , MIDSIZE)

end


local function doMahAlert()
  playAlerts()
  drawAlerts()
end

local function draw()
  drawAlerts()
end


----------------------------------------------------------------
--
----------------------------------------------------------------
local function init_func()
  doMahAlert()
end
--------------------------------


----------------------------------------------------------------
--  Should handle any flow needed when the screen is NOT visible
----------------------------------------------------------------
local function bg_func()
  playAlerts()
end
--------------------------------


----------------------------------------------------------------
--  Should handle any flow needed when the screen is visible
--  All screen updating should be done by as little (one) function
--  outside of this run_func
----------------------------------------------------------------
local function run_func(event)
    if event == 64 then
      lcd.clear()
      lcd.drawText(0, 10, "WE GOT HERE")
    else

    -- Respond to user KeyPresses for mahSetup
      if event == EVT_PLUS_FIRST then
        mahTarget = mahTarget + 10
      end

      if event == EVT_MINUS_FIRST then
        mahTarget = mahTarget - 10
      end

  --Update our screen
      lcd.clear()

      lcd.drawText(0, 10, event)

      lcd.drawText(130, 20, "Target mAh : ",MIDSIZE)
      lcd.drawText(160, 35, mahTarget,MIDSIZE)
      lcd.drawText(130, 50, "Use +/- to change",SMLSIZE)

      lcd.drawGauge(6, 35, 70, 20, percVal, 100)
      lcd.drawScreenTitle(versionInfo,1,1)

      draw()
      doMahAlert()
  end
end
--------------------------------

return {run=run_func, background=bg_func, init=init_func  }
