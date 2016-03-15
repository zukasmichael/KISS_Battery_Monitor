
# KISS_Battery_Monitor
Open TX Telemetry Script for reading and announcing battery mAh consumption.  Uses the mAh consumption as reported from KISS 24a ESC as Telemetry data and accepts a configurable user Target mAH and Percentage Notification.  The pilot can target how much mAh they intend to use that flight, adjust this value as needed, and this will be used as the "Battery".  The Percentage Notification allow for the pilot to receive verbal indication of the "Battery" at the desired intervals.  During the final 10% of the "Battery" an indication is given at every 1%.   After 100% usage of the "Battery" each additional % used will trigger a "Battery Critical" alarm.

# SCREENSHOTS
See the WIKI for more detailed information and screenshots on installation, and usage.  https://github.com/DynamikArray/KISS_Battery_Monitor/wiki


# REQUIREMENTS
* KISS 24a ESC
* OPEN TX 2.1 Firmware on Taranis

# INSTALLATION:
Download the latest release from the https://github.com/DynamikArray/KISS_Battery_Monitor/releases and place the file (KISSdata.lua) in the following directory on the SD_CARD of your Taranis.
``` SCRIPTS\TELEMETRY ```  (if the TELEMETRY folder does not exist then you may need to create it)

# SETUP:
Attach this script to one of your TELEMETRY screens inside your radio.

# USAGE
There are two parameters the Pilot may adjust as needed.
* Target mAh = The amount of mAh the pilot wants to consume.  
* Notification Percentage = The Percentages the pilot wants the verbal alerts to trigger.

On the main screen of the script, you may adjust the target mAh at anytime using by holding down either of the +/- keys to adjust the value.

Percentages Notification adjust may be accessed by pressing the [MENU] key.  On the Percentages Notification Screen you may adjust the Percentage using the +/- keys.  Pressing the [MENU] key again will bring you back to the main screen of this script.

# Known Issues:
The Telemetry data is not visible for viewing after RSSI loss (ie pilot lands and disconnects battery from multi rotor)
