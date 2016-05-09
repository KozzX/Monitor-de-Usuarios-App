-- This function gets called when the user opens a notification or one is received when the app is open and active.
-- Change the code below to fit your app's needs.
function DidReceiveRemoteNotification(message, additionalData, isActive)
    if (additionalData) then
        if (additionalData.discount) then
            native.showAlert( "Discount!", message, { "OK" } )
            -- Take user to your app store
        elseif (additionalData.actionSelected) then -- Interactive notification button pressed
            native.showAlert("Button Pressed!", "ButtonID:" .. additionalData.actionSelected, { "OK"} )
        end
    else
        native.showAlert("OneSignal Message", message, { "OK" } )
    end
end

local OneSignal = require("plugin.OneSignal")
-- Uncomment SetLogLevel to debug issues.
-- OneSignal.SetLogLevel(4, 4)
OneSignal.Init("525f0212-7b0c-4e0c-aeec-83c57155ac36", "11251378042", DidReceiveRemoteNotification)

OneSignal.EnableNotificationsWhenActive(true)


local composer = require( "composer" )

composer.gotoScene( "splash", {effect = "fade",time = 600} )

display.setDefault( "background", 76/255,38/255,02/255)
display.setStatusBar( display.TranslucentStatusBar )