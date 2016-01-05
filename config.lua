application =
{

	content =
	{
		width  = 320,
		height = 480, 
		scale  = "zoomEven",
		fps    = 60,
		xAlign = "left",
		yAlign = "top",
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
