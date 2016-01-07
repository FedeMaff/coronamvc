	--------------------------------------------------------
	-- Object view
	--------------------------------------------------------
	local View  = {}
	
	local class_ = { __index = View }

	function View.new( data )
		
		return setmetatable( { data = data }, class_)		
	end	

	
	--------------------------------------------------------
	-- Create is a required method of object view istance
	--------------------------------------------------------
	function View:Create()
		
		
		self.gruppo = display.newGroup()
		
		self.label = display.newText({
			
			parent = self.gruppo,
			width  = W,
			x = W*0.5,
			y = H*0.5,
			text = self.data.label,
			align = "center",
			fontSize = 20
			
		})
		
		self.click = function(event)
			
			if event.phase == "began" then
				
				if self.data.pagina == 1 then
				
					mvc.main:test2()
					
				elseif self.data.pagina == 2 then
				
					mvc.main:test3()
				else
				
					mvc.main:test4()
				end
			end
		end
		
		return self.gruppo
		
	end
	
	
	--------------------------------------------------------
	-- Show is a required method of object view istance
	--------------------------------------------------------
	function View:Show()
		
		
		self.label:addEventListener("touch", self.click )
		
	end

	
	--------------------------------------------------------
	-- Hide is a required method of object view istance
	--------------------------------------------------------
	function View:Hide()
		
		self.label:removeEventListener("touch", self.click )
	
	end	

	
	--------------------------------------------------------
	-- Delete is a required method of object view istance
	--------------------------------------------------------
	function View:Delete()
	end	
	
	return View	
	