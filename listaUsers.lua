---------------------------------------------------------------------------------
--
-- listaUsers.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene(  )
local json = require "json"
local Lista = require( "Lista" )
local OneSignal = require("plugin.OneSignal")
local statusSize = display.topStatusBarContentHeight
local myUser

---------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view


 
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    local params = event.params

    if (phase == "will") then
        local fadeBlack = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
        fadeBlack:setFillColor( 0,0,0 )
        fadeBlack.alpha = 0

        local loading = display.newImage("images/loading.png", display.contentWidth/2 , display.contentHeight / 2)
        --btnLoading:scale( 1, 3 )
        loading.alpha = 0

        local function spin(  )
            loading:rotate( 10 )
        end
        Runtime:addEventListener( "enterFrame", spin )
                
        local actionBar = display.newRect( display.contentCenterX, 0, display.contentWidth, display.contentHeight / 100 * 12 )
        actionBar:setFillColor( 96/255,58/255,22/255 )
        actionBar.anchorY = 0
        local title = display.newText( "Monitor de Usuários", 70, actionBar.height / 2, native.systemFont, 25)
        title.anchorX = 0
        title:setFillColor( 1,1,1 )
        local btnList = display.newImage("images/list.png", 30, actionBar.height / 2)
        btnList:scale( 0.30, 0.37 )
        local btnRefresh = display.newImage("images/refresh.png", display.contentWidth - 40, actionBar.height / 2)
        btnRefresh:scale( 0.37, 0.37 )
        
        local sideList = display.newRect( 0, 0, display.contentWidth / 1.2, display.contentHeight )
        sideList.anchorX = 0
        sideList.anchorY = 0
        sideList:setFillColor( 106/255,68/255,42/255 )
        
        
        local btnBack = display.newImage("images/back.png", 40, actionBar.height / 2)
        btnBack:scale( 0.35, 0.35 )

        local txtUser = display.newText( "usuario", 80, actionBar.height / 2, native.systemFont, 25)
        txtUser.anchorX = 0
        txtUser:setFillColor( 1,1,1 )
        local txtDisponivel = display.newText( "disponiveis", 80, actionBar.height / 2 * 1.5, native.systemFont, 15)
        txtDisponivel.anchorX = 0
        txtDisponivel:setFillColor( 1,1,1 )
        local txtLogado = display.newText( "logado", 80, actionBar.height / 2 * 1.9, native.systemFont, 15)
        txtLogado.anchorX = 0
        txtLogado:setFillColor( 1,1,1 )
        local menuSideList = display.newRect( 0, actionBar.height*1.7, display.contentWidth / 1.2, display.contentHeight-actionBar.height*1.7 )
        menuSideList:setFillColor( 0.8,0.8,0.8 )
        menuSideList.anchorX = 0
        menuSideList.anchorY = 0
        
        local sideTable = display.newGroup( )
        sideTable:insert( sideList )
        sideTable:insert( btnBack )
        sideTable:insert( txtUser )
        sideTable:insert( txtDisponivel )
        sideTable:insert( txtLogado )
        sideTable:insert( menuSideList )
        sideTable.alpha = 0
        
        sideTable.x = -display.contentWidth / 1.2
        sideTable.anchorX = 1
        
        
        local tabela = display.newGroup( )
        local list = Lista.new()
        
        tabela:insert( list )
        tabela:insert( actionBar )
        tabela:insert( title )
        tabela:insert( btnList )
        tabela:insert( btnRefresh )
        tabela:insert( fadeBlack )
        tabela:insert( sideTable )
        

        sceneGroup:insert( tabela )
        
        tabela.y = statusSize
        tabela.height = tabela.height - statusSize


        
        local function showSide( event )
            if (sideTable.visible ~= true) then
                print( "show" )
                transition.to( sideTable, {x=0,time=150} )
                list:setIsLocked( true )
                fadeBlack.alpha = 0.8
                sideTable.visible = true
            else
                print( "hide" )
                transition.to( sideTable, {x=-display.contentWidth / 1.2,time=150} )
                list:setIsLocked( false )
                fadeBlack.alpha = 0
                sideTable.visible = false
            end
        
        end
        btnList:addEventListener( "tap", showSide)
        
        
        
        
        local function getListUsers( event )
            local data = json.decode(event.response)
         
            if ( event.isError ) then
                print( "Network error!" )
            else
                list:deleteAllRows( )
                print(event.response)
                list:inserir(data)
                txtDisponivel.text = tostring(35-#data) .. " usuários disponíveis"
                for i=1,#data do
                    if myUser.CODUSU == data[i].CODUSU then
                        txtLogado.text = "Você está no sistema."
                        break
                    else
                        txtLogado.text = "Você não está no sistema."
                    end

                end
                fadeBlack.alpha = 0
                loading.alpha = 0
                if sideTable.primeiro ~= false then
                    timer.performWithDelay( 1000, function (  )
                        sideTable.alpha = 1
                        showSide() 
                        sideTable.primeiro = false    
                    end , 1 )
                    
                end
            end
        end
        
        

        local function getMyUser( event )
            local data = json.decode(event.response)
         
            if ( event.isError ) then
                print( "Network error!" )
            else
                OneSignal.SendTag("username", data[1].NOMUSU)
                txtUser.text = data[1].NOMUSU
                print(data[1].NOMUSU, data[1].CODUSU, data[1].INTNET)
                myUser = data[1]
                network.request( "http://192.168.50.170:7979/monitor_usuarios/webservice/consulta.php","GET",getListUsers )                
            end
        end 
        
        local function refresh( event )
            fadeBlack.alpha = 0.8
            loading.alpha = 1
            network.request( "http://192.168.50.170:7979/monitor_usuarios/webservice/consulta.php/?user="..params.login,"GET",getMyUser )        
        end

        btnRefresh:addEventListener( "tap", refresh )
        refresh()        

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