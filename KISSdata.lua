local versionInfo = "KISS Telemetry Data - v1.2.2"

local blnMenuMode = 0

-- mahTarget is used to set our target mah consumption and mahAlertPerc is used for division of alerts
local mahTarget = 900
local mahAlertPerc = 10

local lastMahAlert = 0

local minorVersion = 99

----------------------------------------------------------------
-- Custom Functions
----------------------------------------------------------------
local function getRadioVersion()
  local ver, radio, minor = getVersion()
  minorVersion = minor
  return 1
end

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
  -- playNumber(minorVersion)
  playNumber(99,1)
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

  lcd.drawText(5, 10, "USED: "..curMah.."mah" , MIDSIZE)
  lcd.drawText(90, 30, percVal.." %" , MIDSIZE)

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
  getRadioVersion()
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




  if blnMenuMode == 1 then
    --We are in our menu mode

    if event == 32 then
      --Take us out of menu mode
        blnMenuMode = 0
    end

    -- Respond to user KeyPresses for mahSetup
      if event == EVT_PLUS_FIRST then
        mahAlertPerc = mahAlertPerc + 1
      end

      -- Long Presses
      if event == 68 then
        mahAlertPerc = mahAlertPerc + 1
      end

      if event == EVT_MINUS_FIRST then
        mahAlertPerc = mahAlertPerc - 1
      end

      -- Long Presses
      if event == 69 then
        mahAlertPerc = mahAlertPerc - 1
      end


    lcd.clear()

    lcd.drawScreenTitle(versionInfo,2,2)
    lcd.drawText(35,10, "Set Percentage Notification")
    lcd.drawText(70,20,"Every "..mahAlertPerc.." %",MIDSIZE)
    lcd.drawText(66, 35, "Use +/- to change",SMLSIZE)

    lcd.drawText(60, 55, "Press [MENU] to return",SMLSIZE)

  else

  if event == 32 then
    --Put us in menu mode
      blnMenuMode = 1
  end

    -- Respond to user KeyPresses for mahSetup
      if event == EVT_PLUS_FIRST then
        mahTarget = mahTarget + 1
      end

      if event == 68 then
        mahTarget = mahTarget + 1
      end

      if event == EVT_MINUS_FIRST then
        mahTarget = mahTarget - 1
      end

      if event == 69 then
        mahTarget = mahTarget - 1
      end


    --Update our screen
      lcd.clear()

      lcd.drawScreenTitle(versionInfo,1,2)

      lcd.drawGauge(6, 25, 70, 20, percVal, 100)
      lcd.drawText(130, 10, "Target mAh : ",MIDSIZE)
      lcd.drawText(160, 25, mahTarget,MIDSIZE)
      lcd.drawText(130, 40, "Use +/- to change",SMLSIZE)

      lcd.drawText(30, 55, "Press [MENU] for more options",SMLSIZE)

      draw()
      doMahAlert()
  end

end
--------------------------------

return {run=run_func, background=bg_func, init=init_func  }
