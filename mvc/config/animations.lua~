
	-- ----------------------------------------------
	-- Animation run travel between views
	-- ----------------------------------------------
	
	Animations = {}
	
	Animations.HideTime  = 0
	Animations.TransTime = 600
	
	Animations.getHideTime = function( view )
		
		if view.view.HideTime ~= nil and type(view.view.HideTime) == "number" then
			
			return view.view.HideTime
		else 
		
			return Animations.HideTime
		end
	
	end
	
	Animations["BASE"] = function ( NewView, OldView, delete ) 
		
		local time = Animations.getHideTime( OldView )
		
		OldView.view:Hide()
		
		timer.performWithDelay( time, function() 
			
			if delete == true then
				mvc:delete_view(OldView)
			end
			NewView.view:Show()
			
		end, 1)
		
	end
	
	Animations["SLIDE_LEFT"] = function ( NewView, OldView, delete ) 
		
		local time = Animations.getHideTime( OldView )
		
		NewView.group.x = W
		NewView.group.y = 0
		
		OldView.view:Hide()
				
		timer.performWithDelay( time, function() 
		
			transition.to( OldView.group, { time=Animations.TransTime, x=-W, transition=easing.inOutExpo })
			transition.to( NewView.group, { time=Animations.TransTime, x=0, transition=easing.inOutExpo, onComplete=function()
			
				if delete == true then
				
					mvc:delete_view(OldView)
				end
				
				NewView.view:Show()
			
			end})
		
		end, 1)
		
	end
	
	Animations["SLIDE_RIGHT"] =  function ( NewView, OldView, delete ) 
		
		local time = Animations.getHideTime( OldView )
		
		NewView.group.x = -W
		NewView.group.y = 0
		
		OldView.view:Hide()
				
		timer.performWithDelay( time, function() 
		
			transition.to( OldView.group, { time=Animations.TransTime, x=W, transition=easing.inOutExpo })
			transition.to( NewView.group, { time=Animations.TransTime, x=0, transition=easing.inOutExpo, onComplete=function()
			
				if delete == true then
				
					mvc:delete_view(OldView)
				end
				
				NewView.view:Show()
			
			end})
		
		end, 1)
		
	end
	
	Animations["SLIDE_BOTTOM"] =  function ( NewView, OldView, delete ) 
		
		local time = Animations.getHideTime( OldView )
		
		NewView.group.x = 0
		NewView.group.y = H
		
		OldView.view:Hide()
				
		timer.performWithDelay( time, function() 
		
			transition.to( OldView.group, { time=Animations.TransTime, y=-H, transition=easing.inOutExpo })
			transition.to( NewView.group, { time=Animations.TransTime, y=0, transition=easing.inOutExpo, onComplete=function()
			
				if delete == true then
				
					mvc:delete_view(OldView)
				end
				
				NewView.view:Show()
			
			end})
		
		end, 1)
		
	end
	
	Animations["SLIDE_TOP"] =  function ( NewView, OldView, delete ) 
		
		local time = Animations.getHideTime( OldView )
		
		NewView.group.x = 0
		NewView.group.y = -H
		
		OldView.view:Hide()
				
		timer.performWithDelay( time, function() 
		
			transition.to( OldView.group, { time=Animations.TransTime, y=H, transition=easing.inOutExpo })
			transition.to( NewView.group, { time=Animations.TransTime, y=0, transition=easing.inOutExpo, onComplete=function()
			
				if delete == true then
				
					mvc:delete_view(OldView)
				end
				
				NewView.view:Show()
			
			end})
		
		end, 1)
		
	end