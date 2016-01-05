	
	----------------------------------------------------------
	-- Dependencies configuration
	----------------------------------------------------------
	
	require "mvc.config.constants"
	require "mvc.config.roots"
	require "mvc.config.autoload"
	require "mvc.config.animations"
	
	
	--------------------------------------------------------
	-- Core mvc
	--------------------------------------------------------
	
	core = require "mvc.core.mvc"
	
	
	--------------------------------------------------------
	-- Instance of class mvc
	--------------------------------------------------------
	
	mvc = core.new( autoload, roots )
	
	mvc:start()