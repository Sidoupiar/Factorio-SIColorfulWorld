-- ------------------------------------------------------------------------------------------------
-- --------- 创建原型机 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------



-- ------------------------------------------------------------------------------------------------
-- ------- 创建像素调色板 -------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local pixelPanelSource = ""

-- ------------------------------------------------------------------------------------------------
-- --------- 创建像素板 ---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "pixel-panel" )
for r = 0 , 256 , 32 do
	for g = 0 , 256 , 32 do
		for b = 0 , 256 , 32 do
			local tint = SIPackers.Color256( r , g , b )
			SIGen.NewHealthEntity( SITypes.entity.simpleEntity , "pixel-panel"..r.."-"..g.."-"..b )
			.SetLocalisedNames{ "entity-name.sicw-pixel-panel" , r , g , b }
			.SetLocalisedDescriptions{ "entity-description.sicw-pixel-panel" , r , g , b }
			.SetProperties( 1 , 1 , 10 )
			.SetCorpse( "small-remnants" , "small-explosion" )
			.SetMapColor( tint )
			.SetCustomData
			{
				placeable_by = { item = pixelPanelSource , count = 1 } ,
				icons = SIPackers.Icon( SICW.picturePath.."item/pixel-panel.png" , tint , 4 ) ,
				pictures = SIPics.NewLayer( SICW.picturePath.."entity/pixel-panel/pixel-panel.png" , 32 , 32 ).Priority( SIPics.priority.veryLow ).Tint( tint ).Get() ,
				render_layer = "object" ,
				mined_sound = SISounds.Sound( "__base__/sound/deconstruct-bricks.ogg" , 1 ) ,
				vehicle_impact_sound = SISounds.Sound( "__base__/sound/car-metal-impact.ogg" , 1 ) ,
				repair_sound = SISounds.Sound( "__base__/sound/manual-repair-simple.ogg" , 1 )
			}
		end
	end
end