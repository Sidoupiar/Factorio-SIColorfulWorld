load()

-- ------------------------------------------------------------------------------------------------
-- ----------- 初始化 -----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen
.Init( SICW )
.NewGroup( "多彩生物" )
needlist( "zprototype/1_biology" , "1_slime" , "2_tiny" , "3_fairy" )

SIGen.NewGroup( "焦馏工艺" )
needlist( "zprototype/2_carbon" , "1_resource" )

SIGen.NewGroup( "颜色革命" )
needlist( "zprototype/3_color" , "1_pixel" )

SIGen.Finish()