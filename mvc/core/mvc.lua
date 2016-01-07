
	local Mvc = {}
	local Mvc_ = { __index = Mvc }
	
	function Mvc.new( autoload, roots )
		
		local data = {}
		
		data.views 	  = {}
		data.ui		  = display.newGroup()
		data.roots 	  = roots
		data.autoload = autoload
		
		return setmetatable( data, Mvc_)
	end	
	
	function Mvc:start()
		
		for i,model in pairs( self.autoload.models ) do
			
			local resurce = require( MPATH .. "." .. model )
			self[model] = resurce.new()
				
		end
		
		for i,controller in pairs( self.autoload.controllers ) do
			
			local resurce = require( CPATH .. "." .. controller )
			self[controller] = resurce.new()
				
		end
		
		for name,class in pairs(self) do
			
			if name == self.roots.main.controller then
			
				class[self.roots.main.method](class)
				
			end
			
		end
		
		self.group = display.newGroup()
		
		
	end
	
	function Mvc:get_view( name )
		
		for n,view in pairs(self.views) do
			
			if name == view.name then
				
				return view
								
			end			
		end
		
		return false
		
	end
	
	function Mvc:get_back_view( name )
		
		for i=1, #self.views, 1 do
			
			if name == self.views[i].name and i > 1 then
				
				return self.views[i-1]
			
			end	
		end
		
		return false
	end
	
	function Mvc:get_view_content_of( name )
		
		local view = self:get_view( name )
		
		return view.parent
	end
	
	function Mvc:load_view( name, alias, data )
		
		if name ~= nil then
			
			local resurce = require( VPATH .. "." .. name )
		
			local ViewObject = resurce.new( data )
			
			local ViewContent = display.newGroup()
		
			if type(alias) == "string" then
				
				name = alias
			
			elseif type(alias) == "table" and data == nil then
				
				data = alias
				
			end
		
			local view = {
			
				name   = name,
				parent = ViewContent,
				view   = ViewObject,
				group  = ViewObject:Create()
			}
			
			self.ui:insert(ViewContent)
			view.parent:insert(view.group)
			
			table.insert( self.views, #self.views+1, view )
			
			view.view:Show()
			
		end
	end
	
	function Mvc:load_view_in_view( name, alias, data, parent_name, animation, delete )
		
		if name ~= nil then
			
			local resurce = require( VPATH .. "." .. name )
		
			local ViewObject = resurce.new( data )
		
			if type(alias) == "string" then
				
				name = alias
				
				if type(animation) == "boolean" then
				
					delete 	  = animation
					animation = nil
				end
			
			elseif type(alias) == "table" and type(data) == "string" then
				
				if type(parent_name) ~= "bolean" then
				
					delete	  = animation
					animation = parent_name
				else
				
					delete 	  = parent_name
					animation = nil
				end
			
				parent_name = data
				data 		= alias
				
			end
			
			
			local ViewContent = self:get_view_content_of( parent_name )
			
			
			local view = {
			
				name   = name,
				parent = ViewContent,
				view   = ViewObject,
				group  = ViewObject:Create()
			}
			
			view.parent:insert(view.group)
			table.insert( self.views, #self.views+1, view )
			
			delete 	  = delete or false
			animation = animation or DEFAULT_NEXT_ANIMATION
			
			Animations[animation]( view, self:get_view( parent_name ), delete)
			
		end
	end
	
	function Mvc:back( view, animation )
		
		if view ~= nil then
			
			animation 	 = animation or DEFAULT_BACK_ANIMATION
			Animations[animation]( self:get_back_view( view ), self:get_view( view ), true)
			
		end
	end
	
	function Mvc:back_to(view, target_view, animation )
		
		if view ~= nil and target_view ~= nil then
			
			animation 	 = animation or DEFAULT_BACK_ANIMATION
			
			local destinazione = self:get_view( target_view )
			local partenza 	   = self:get_view( view )
			
			Animations[animation]( destinazione, partenza, true)
			
			self:delete_after_view( destinazione )
			
		end
		
	end
	
	function Mvc:delete_after_view( view_object )
		
		local delete = false
		
		for n,view in pairs(self.views) do
			
			if delete == true then
				
				view.view:Delete()
				view.group:removeSelf()
				table.remove( self.views, n )
			end
			
			if view_object.name == view.name then
			
				delete = true
			end	
		end
	end
	
	function Mvc:delete_view( view_object )
		
		for n,view in pairs(self.views) do
			
			if view_object.name == view.name then
				
				view.view:Delete()
				view.group:removeSelf()
				table.remove( self.views, n )				
			end			
		end
		
	end
	
	return Mvc;