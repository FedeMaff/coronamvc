
	-- ----------------------------------------------
	-- Paths
	-- ----------------------------------------------
	
	MVCPATH 	= 'mvc'
	APPPATH 	= MVCPATH .. '.application'
	CPATH   	= APPPATH .. '.controllers'
	MPATH   	= APPPATH .. '.models'
	VPATH   	= APPPATH .. '.views'
	
	
	-- ----------------------------------------------
	-- Dimensions
	-- ----------------------------------------------
	
	H = display.viewableContentHeight
	W = display.viewableContentWidth
	
	-- ----------------------------------------------
	-- View in view default coords views render
	-- ----------------------------------------------
	X = W
	Y = 0
	
	
	-- ----------------------------------------------
	-- Animations details
	-- ----------------------------------------------
	DEFAULT_ANIMATION = "BASE"