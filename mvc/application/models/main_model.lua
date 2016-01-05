
	local Main_model  = {}
	local class_ = { __index = Main_model }

	function Main_model.new()
		
		return setmetatable( {}, class_)		
	end	
	
	function Main_model:prova()
		
		local par = { label = "Clickme!", pagina = 1}
		
		return par
		
	end
	
	function Main_model:prova2()
		
		local par = { label = "This is lua MVC!", pagina = 2}
		
		return par
		
	end
	
	return Main_model;