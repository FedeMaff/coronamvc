
	local Test_model  = {}
	local class_ = { __index = Test_model }

	function Test_model.new()
		
		return setmetatable( {}, class_)		
	end	
	
	function Test_model:prova()
		
		return "TEST MODEL"
	end
	
	return Test_model;