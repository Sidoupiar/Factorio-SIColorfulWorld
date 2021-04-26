-- ------------------------------------------------------------------------------------------------
-- --------- 创建原型机 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "像素块" )

-- ------------------------------------------------------------------------------------------------
-- ------- 创建像素调色盘 -------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local painterItem = SIGen.NewItem( "像素块调色盘" , 1 )
.AddFlags{ SIFlags.itemFlags.notStackable }
.SetCustomData
{
	type = SITypes.item.selectionTool ,
	show_in_library = false ,
	selection_color = { 0.00 , 0.00 , 0.00 } ,
	selection_mode = { "any-entity" } ,
	selection_cursor_box_type = "copy" ,
	alt_selection_color = { 1.00 , 1.00 , 1.00 } ,
	alt_selection_mode = { "any-entity" } ,
	alt_selection_cursor_box_type = "copy"
}
.GetCurrentEntityName()

-- ------------------------------------------------------------------------------------------------
-- --------- 创建像素块 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local pixelPanelSource = SIGen.NewItem( "像素块母板" , 100 ).SetResults( "sicw-simple-像素块-256-256-256" ):GetCurrentEntityName()
for r = 0 , SICW.colorMax , SICW.colorStep do
	for g = 0 , SICW.colorMax , SICW.colorStep do
		for b = 0 , SICW.colorMax , SICW.colorStep do
			local tint = SIPackers.Color256( r , g , b )
			SIGen.NewHealthEntity( SITypes.entity.simpleOwner , "像素块-"..r.."-"..g.."-"..b )
			.SetFlags{ SIFlags.entityFlags.placeablePlayer , SIFlags.entityFlags.playerCreation }
			.SetLocalisedNames{ "entity-name.sicw-simple-像素块" , r , g , b }
			.SetLocalisedDescriptions{ "entity-description.sicw-simple-像素块" , r , g , b }
			.SetProperties( 1 , 1 , 10 )
			.SetMinable( { mining_time = 0.05 , result = pixelPanelSource } , { item = pixelPanelSource , count = 1 } )
			.SetCorpse( "small-remnants" , "wall-explosion" )
			.SetMapColor( tint )
			.SetCustomData
			{
				icons = { SIPackers.Icon( SICW.picturePath.."item/像素块" , tint , 4 ) } ,
				collision_box = SIPackers.CollisionBoundBox( 0.1 , 0.1 ) ,
				render_layer = "object" ,
				pictures = SIPics.NewLayer( SICW.picturePath.."entity/像素块/像素块" , 32 , 32 ).Priority( SIPics.priority.veryLow ).Tint( tint ).Get() ,
				mined_sound = SISounds.Sound( "__base__/sound/deconstruct-bricks.ogg" , 1 ) ,
				vehicle_impact_sound = SISounds.Sound( "__base__/sound/car-metal-impact.ogg" , 1 ) ,
				repair_sound = SISounds.Sound( "__base__/sound/manual-repair-simple.ogg" , 1 )
			}
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建界面 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewStyle( "调色盘" ,
{
	type = "frame_style" ,
	parent = "frame" ,
	
	minimal_width = 100 ,
	minimal_height = 100 ,
	maximal_height = 700
} )
.NewStyle( "调色盘说明" ,
{
	type = "label_style" ,
	
	width = 400 ,
	
	horizontal_align = "left"
} )
.NewStyle( "调色盘列表" ,
{
	type = "table_style" ,
	
	cell_spacing = 0 ,
	horizontal_spacing = 0 ,
	vertical_spacing = 0
} )
.NewStyle( "调色盘色块" ,
{
	type = "button_style" ,
	parent = "button" ,
	
	top_padding = 0 ,
	right_padding = 0 ,
	bottom_padding = 0 ,
	left_padding = 0 ,
	
	minimal_width = 21 ,
	minimal_height = 21
} )