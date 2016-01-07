
	local Error  = {}
	local class_ = { __index = Error }

	function Error.new()
		
		local error_list = {}
		
		table.insert( error_list, 1, "Stai cercando di istanziare {$1}: '{$2}' ma la classe '{$2}' è gia stata istanziata..." )
		table.insert( error_list, 2, "{$1} '{$2}.lua' non esiste" )
		
		return setmetatable( { error_list = error_list }, class_)		
	end	
	
	function Error:die( n, par )
		
		local par = par or {}
		
		local message = [[Kimi [ERR0]] .. n .. [[]: ]] .. self.error_list[tonumber(n)]
		
		for i,str in pairs(par) do
			
			message = string.gsub( message, "{$" .. i .. "}", str)
			
		end
		
		print( message )
			
	end
	
	return Error;