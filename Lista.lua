local widget = require( "widget" )

local rowData
local tableView

local function printTable( t, label, level )
	if label then print( label ) end
	level = level or 1

	if t then
		for k,v in pairs( t ) do
			local prefix = ""
			for i=1,level do
				prefix = prefix .. "\t"
			end

			print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
			if type( v ) == "table" then
				print( prefix .. "{" )
				printTable( v, nil, level + 1 )
				print( prefix .. "}" )
			end
		end
	end
end



function new(  )

	local function onRowTouch( event )
		if (event.phase == "tap") then
			local index = event.target.index
			local row = event.target

			if tableView._view._rows[index].selected ~= true then
				tableView._view._rows[index]._rowColor.default = { 1, 100/255, 100/255 }
				tableView._view._rows[index].selected = true
			else
				tableView._view._rows[index]._rowColor.default = { 0.9, 0.9, 0.9 }
				tableView._view._rows[index].selected = false
			end

			tableView:reloadData()

			print( rowData[index].CODUSU,rowData[index].NOMUSU )
		end
	end

	local function onRowRender( event )
    -- Get reference to the row group
        local row = event.row


	    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
	    local rowHeight = row.contentHeight
	    local rowWidth = row.contentWidth
	    
	    local rowTitle = display.newText( row, row.params.CODUSU .. " " .. row.params.NOMUSU, 0, 0, nil, 20 )
    	rowTitle:setFillColor( 0 )
        row.x = 0
    	row.alpha = 0

    	
    	-- Align the label left and vertically centered
    	rowTitle.anchorX = 0
    	rowTitle.x = 30
    	rowTitle.y = rowHeight * 0.5


    	transition.to( row, {x=0,time=150} )
    	transition.to( row, {alpha=1,time=100} )
	end

	tableView = widget.newTableView {
    	x = display.contentCenterX,
    	y = display.contentCenterY + (display.contentHeight / 100 * 12) / 2,
    	height = display.contentHeight / 100 * 88,
    	width = display.contentWidth,
    	noLines = true,
    	isBounceEnabled = false,
    	rowTouchDelay = 600,
    	friction = 0.95,
    	maxVelocity = 20,
    	backgroundColor = { 1 },
    	onRowRender = onRowRender,
    	onRowTouch = onRowTouch,
    	listener = scrollListener
	}	

	local function onRowTouch( event )
		if (event.phase == "tap") then
			local index = event.target.index
			
			printTable(tableView:getRowAtIndex(index),"Table")
			
		end
	end

	function tableView:inserir(data)
        local i = 1
        rowData = data
		timer.performWithDelay( 1, function (  )
            tableView:insertRow {
                isCategory = false,
                rowColor= { default={ 0.9, 0.9, 0.9 },over={ 0.9, 0.9, 0.9 }},
                rowHeight = 80,
                lineColor={0},
                params = {CODUSU=data[i].CODUSU, NOMUSU=data[i].NOMUSU}
            } 
            i = i +1   
        end , #data )
	end

    return tableView
end

return {
	new = new
}
