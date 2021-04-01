load()

-- ------------------------------------------------------------------------------------------------
-- ----------- 初始化 -----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen
.Init( SICW )
.NewGroup( "biology" )
needlist( "zprototype/biology" , "slime" , "fairy" , "tiny" )

SIGen.NewGroup( "carbon-coke" )
needlist( "zprototype/carbon_coke" , "1_resource" )

SIGen.NewGroup( "paint" )
needlist( "zprototype/paint" , "color_block" )

SIGen.Finish()