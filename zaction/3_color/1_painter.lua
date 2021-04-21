-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIPainter =
{
	itemName = "sicw-item-像素块调色盘" ,
	entityNamePrefix = "sicw-simple-像素块" ,
	buttonName = "sicw-调色盘色块-" ,
	
	settingsDefaultData =
	{
		entities = {} ,
		pixel = nil ,
		view = nil ,
		label = nil
	}
}

SIPainter.buttonPosition = #SIPainter.buttonName + 1

SIGlobal.Create( "painter" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 窗口方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIPainter.OpenView( playerIndex )
	local player = game.players[playerIndex]
	local settings = SIPainter.GetSettings( playerIndex )
	if settings.view then SIPainter.CloseView( playerIndex )
	else
		local view = player.gui.center.add{ type = "frame" , name = "sicw-调色盘" , caption = { "SICW.调色盘标题" } , direction = "vertical" , style = "sicw-调色盘" }
		
		view.add{ type = "label" , caption = { "SICW.调色盘使用方法" } , style = "sicw-调色盘说明" }
		settings.label = view.add{ type = "label" , caption = { "SICW.调色盘当前颜色" , 0 , 0 , 0 } , style = "sicw-调色盘说明" }
		
		local list = view.add{ type = "scroll-pane" , horizontal_scroll_policy = "never" , vertical_scroll_policy = "auto-and-reserve-space" }.add{ type = "table" , column_count = math.ceil( SICW.colorMax/SICW.colorStep+1 )*3 , style = "sicw-调色盘列表" }
		for r = 0 , SICW.colorMax , SICW.colorStep do
			for g = 0 , SICW.colorMax , SICW.colorStep do
				for b = 0 , SICW.colorMax , SICW.colorStep do
					list.add{ type = "sprite-button" , name = SIPainter.buttonName..r.."-"..g.."-"..b , sprite = "entity/sicw-simple-像素块-"..r.."-"..g.."-"..b , tooltip = { "SICW.调色盘当前颜色" , r , g , b } , style = "sicw-调色盘色块" }
				end
			end
		end
		
		flow = view.add{ type = "flow" , direction = "horizontal" }
		flow.add{ type = "button" , name = "sicw-调色盘关闭" , caption = { "SICW.调色盘关闭" } , style = "sicfl-view-button-red" }
		flow.add{ type = "button" , name = "sicw-调色盘染色" , caption = { "SICW.调色盘染色" } , style = "sicfl-view-button-green" }
		
		settings.view = view
	end
end

function SIPainter.CloseView( playerIndex )
	local settings = SIPainter.GetSettings( playerIndex )
	if settings then
		if settings.view then
			settings.entities = {}
			settings.pixel = nil
			
			settings.view.destroy()
			settings.view = nil
			settings.label = nil
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 功能方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIPainter.GetSettings( playerIndex )
	local settings = painter[playerIndex]
	if not settings then
		settings = table.deepcopy( SIPainter.settingsDefaultData )
		painter[playerIndex] = settings
	end
	return settings
end

function SIPainter.ChangeLabel( settings )
	if settings then
		if settings.pixel then settings.label.caption = { "SICW.调色盘当前颜色" , settings.pixel[1] , settings.pixel[2] , settings.pixel[3] }
		else settings.label.caption = { "SICW.调色盘当前颜色" , 0 , 0 , 0 } end
	end
end

function SIPainter.Paint( settings , player )
	if not settings or #settings.entities < 1 then
		player.print( { "SICW.调色盘像素块不足" } , SIColors.printColor.orange )
		return false
	end
	if not settings.pixel then
		player.print( { "SICW.调色盘无颜色" } , SIColors.printColor.orange )
		return false
	end
	local name = SIPainter.entityNamePrefix .. "-" .. settings.pixel[1] .. "-" .. settings.pixel[2] .. "-" .. settings.pixel[3]
	for i , entity in pairs( settings.entities ) do
		if entity.valid and entity.name ~= name then
			entity.surface.create_entity{ name = name , position = entity.position , direction = entity.direction , force = entity.force , player = player , raise_built = true }
			entity.destroy{ raise_destroy = true }
		end
	end
	return true
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 公用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIPainter.OnSelect( event )
	if event.item == SIPainter.itemName then
		local settings = SIPainter.GetSettings( event.player_index )
		local player = game.get_player( event.player_index )
		settings.entities = {}
		for i , v in pairs( event.entities ) do
			if v.force == player.force and v.name:StartsWith( SIPainter.entityNamePrefix ) then
				table.insert( settings.entities , v )
			end
		end
		if not settings.view then SIPainter.OpenView( event.player_index ) end
	end
end

function SIPainter.OnClickView( event )
	local element = event.element
	if element.valid then
		local name = element.name
		if name == "sicw-调色盘染色" then
			local playerIndex = event.player_index
			local settings = SIPainter.GetSettings( playerIndex )
			if SIPainter.Paint( settings , game.get_player( playerIndex ) ) then SIPainter.CloseView( playerIndex ) end
		elseif name == "sicw-调色盘关闭" then SIPainter.CloseView( event.player_index )
		elseif name:StartsWith( SIPainter.buttonName ) then
			local settings = SIPainter.GetSettings( event.player_index )
			settings.pixel = name:sub( SIPainter.buttonPosition ):Split( "-" )
			SIPainter.ChangeLabel( settings )
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus
.Add( SIEvents.on_player_selected_area , SIPainter.OnSelect )
.Add( SIEvents.on_player_alt_selected_area , SIPainter.OnSelect )

.Add( SIEvents.on_gui_click , SIPainter.OnClickView )