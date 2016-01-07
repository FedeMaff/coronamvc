
	local Main_model  = {}
	local class_ = { __index = Main_model }

	function Main_model.new()
		
		return setmetatable( {}, class_)		
	end	
	
	function Main_model:prova()
		
		local par = { label = "Pagina numero 1!", pagina = 1}
		
		return par
		
	end
	
	function Main_model:prova2()
		
		local par = { label = "Pagina numero 2!", pagina = 2}
		
		return par
		
	end
	
	function Main_model:prova3()
		
		local par = { label = "Pagina numero 3!", pagina = 3}
		
		return par
		
	end
	
	return Main_model;