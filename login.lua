---------------------------------------------------------------------------------
--
-- login.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local Database = require( "Database" )

-- Load scene with same root filename as this file
local scene = composer.newScene(  )
local txtUser
local txtPass


---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view


 
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then 

        local placa = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
        placa:setFillColor( 0.8,0.8,0.8 )
        sceneGroup:insert( placa )     

        local function networkListener( event )
            --local data = json.decode(event.response)
            print( event.response )
 
            if ( event.isError ) then
                print( "Network error!" )
            else
                if (event.response == "Sucesso") then
                    composer.gotoScene( "listaUsers", {effect = "fromRight",time = 600,params = {login=txtUser.text}} ) 
                else

                end
            end
        end
        
    
        local function userCallback( event )
            if ( event.phase == "ended" or event.phase == "submitted" ) then
                print( event.target.text )
                native.setKeyboardFocus( txtPass )
            end
        end

        local function passCallback( event )
            if ( event.phase == "submitted" ) then
                print( event.target.text )
                print( txtUser.text,txtPass.text )
                adicionarUsuario(txtUser.text,txtPass.text)
                network.request( "http://192.168.50.170:7979/monitor_usuarios/verificarLogin.php/?user="..txtUser.text.."&pass="..txtPass.text,"GET",networkListener )
            end
        end
        
        
        -- Create text field
        txtUser = native.newTextField( display.contentCenterX,display.contentCenterY-100, display.contentWidth, 40 )
        txtUser.placeholder = "Usuário"
        txtPass = native.newTextField( display.contentCenterX,display.contentCenterY-50, display.contentWidth, 40 )
        txtPass.placeholder = "Senha"

        native.setKeyboardFocus( txtUser )
        txtPass.isSecure = true

        txtUser:addEventListener( "userInput", userCallback )
        txtPass:addEventListener( "userInput", passCallback )

        sceneGroup:insert( txtUser )
        sceneGroup:insert( txtPass )
        
    end
    
    
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
        display.remove( txtUser )
        display.remove( txtPass )

    elseif phase == "did" then
        -- Called when the scene is now off screen
        


    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene