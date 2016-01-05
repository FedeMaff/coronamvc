
	local Demo  = {}
	local class_ = { __index = Demo }

	function Demo.new()
	
		return setmetatable( {}, class_)
	end	
	
	function Demo:test()
		
		mvc:load_view("main", "page1", mvc.main_model:prova())
		
	end
	
	function Demo:test2()
		
		mvc:load_view_in_view("main", "page2", mvc.main_model:prova2(), "page1", "SLIDE_LEFT", true)
		
	end
	
	function Demo:test3()
		
		mvc:load_view_in_view("main", "page1", mvc.main_model:prova(), "page2", "SLIDE_RIGHT", true)
		
	end
	
	return Demo;