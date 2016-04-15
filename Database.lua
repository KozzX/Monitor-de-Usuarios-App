local sqlite3 = require( "sqlite3" )

-- Open "data.db". If the file doesn't exist, it will be created
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )   

-- Handle the "applicationExit" event to close the database
local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then              
        db:close()
    end
end

-- Set up the table if it doesn't exist
local tablesetup = [[CREATE TABLE IF NOT EXISTS USUARIO (
						id integer PRIMARY KEY autoincrement,
						user text, 
						pass text
					);]]

print( tablesetup )
db:exec( tablesetup )

function atualizarUsuario( user,pass )
	local tableupdate = [[UPDATE USUARIO SET user=']]..user..[[', pass=']]..pass..[[' ;]]
	print(tableupdate)
	db:exec( tableupdate )	
end

function adicionarUsuario( user, pass )
	local tablefill = [[INSERT INTO USUARIO (user, pass) VALUES(']]..user..[[', ']]..pass..[[');]]
	print( tablefill )
	db:exec( tablefill )
end

function buscarUsuario(  )
	local result = {}
	for row in db:nrows("SELECT user, pass FROM USUARIO") do
	    result = 
	    {
	    	user=row.user,
	    	pass=row.pass,
		}    
	end
	return result
end

local tablesetup = [[DROP TABLE USUARIO;]]
print( tablesetup )
--db:exec( tablesetup )

-- Setup the event listener to catch "applicationExit"
Runtime:addEventListener( "system", onSystemEvent )

