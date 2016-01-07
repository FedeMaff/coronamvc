	
	local sqlite, json = require "sqlite3", require "json"
	
	local function addslashes(s)
  		
  		local stringa
  		
  		if s == nil then
  			
  			s = ""
  		end
  		
  		stringa = string.gsub(s, "(['])", "'%1")
  		stringa = string.gsub(stringa, "%z", "\\0")
  		
  		return stringa
	
	end
	
	local function file_exists( nome_file, path )
		
		local _file, _path, _complete_path, _fhd
		
		_file 			= nome_file or nil
		_path 			= path or system.DocumentsDirectory
		_complete_path  = system.pathForFile( _file, _path )
		_fhd  			= io.open( _complete_path )
		
		if _fhd then
		
   			_fhd:close()
   			return true
   			
		else
		
    		return false
   		end
		
	end
	
	local function operatore( campo )
		
		local diverso 			= campo:find("(.-)<>", 1) or campo:find("(.-)!=", 1) or "N"
		local maggiore_uguale 	= campo:find("(.-)>=", 1) or "N"
		local minore_uguale 	= campo:find("(.-)<=", 1) or "N"
		
		if diverso == 1 then
		
			return "<>"
			
		elseif maggiore_uguale == 1 then
		
			return ">="
						
		elseif minore_uguale == 1 then
		
			return "<="			
		
		end
		
		return "="
		
	end
	
	local function split( pString, pPattern  )
		
		local ttable = {}  -- NOTE: use {n = 0} in Lua-5.0
   		local fpat = "(.-)" .. pPattern
   		local last_end = 1
   		local s, e, cap = pString:find(fpat, 1)
   		while s do
      		if s ~= 1 or cap ~= "" then
     		table.insert(ttable,cap)
      		end
      	
      		last_end = e+1
      		s, e, cap = pString:find(fpat, last_end)
   		end
   		
   		if last_end <= #pString then
     		cap = pString:sub(last_end)
     		table.insert(ttable, cap)
   		end
   		
   		return ttable
		
	end
	
	local ActiveRecord = {}

	local ActiveRecord_ = { __index = ActiveRecord }
	
	function ActiveRecord.new( dbname, log )
		
		
		_dbname  = dbname or "database"		
		_exists	 = file_exists( _dbname .. ".db" )
		_path 	 = system.pathForFile( tostring(_dbname .. ".db"), system.DocumentsDirectory )
		_conn	 = sqlite.open( _path )
		_log	 = log or "S"
		
		
		local ActiveRecordInterface = {
			
			conn 	= _conn,
			dbname	= _dbname,
			log		= _log,
			this	= {
				
				select = nil,
				from = nil,
				where = nil,
				join = nil,
				order_by = nil,
				group_by = nil,
				limit = nil,
				set = {},
				last_query = ""
				
			}
		}
		
		return setmetatable( ActiveRecordInterface, ActiveRecord_)
	end	
	
	function ActiveRecord:printlog(str)
		
		if self.log == "S" then
		
			print( "\n" .. "SqLite > " .. str )		
		end 
	end 	
	
	function ActiveRecord:chiudi_connessione() 
		
		self:printlog("Chiusa connessione con " .. self.dbname )
	    self.connessione:close()
        
	end	
	
	function ActiveRecord:create(table_name, columns) 
		
		local tblname, campi, riga, query
		
		tblname 	 = table_name or "NULL"
		campi	  	 = columns or "NULL"
		
		
		if tblname == "NULL" or campi == "NULL" then 
			
			ActiveRecord:printlog("campo nome tabella o campi da creare non impostati")
			return false
			
		else
		
			query = [[CREATE TABLE IF NOT EXISTS ]] .. tblname .. [[ (]]
			
			for i=1, #campi, 1 do
				
				local numpar
				
				riga 	= split(campi[i], ", ")
				numpar  = #riga
				
				if i > 1 then
					
					query = query .. [[, ]]
				end
				
				if numpar == 2 then 
					
					query = query .. riga[1] .. [[ ]] .. riga[2]
					
				elseif numpar == 3 then 
					
					query = query .. riga[1] .. [[ ]] .. riga[2] .. [[ ]] .. riga[3]
				end
			end
			
			query = query .. [[)]]
			
			self:query(query)			
		end
	end
	
	function ActiveRecord:reset()
	
		self.this.select = nil
		self.this.from = nil
		self.this.where = nil
		self.this.join = nil
		self.this.order_by = nil
		self.this.group_by = nil
		self.this.limit = nil
		self.this.set = {}
		
	end
		
	function ActiveRecord:select(str)
		
		if self.this.select == nil then
			
			self.this.select = str
		else
			
			self:printlog("Attenzione select gia valorizzato con '" .. self.this.select .. "'")
		end
	end
	
	function ActiveRecord:select_max( campo )
		
		if self.this.select == nil then
			
			self.this.select = [[MAX(]] .. campo .. [[) as ]] .. campo
		else
			
			self:printlog("Attenzione select gia valorizzato con '" .. self.this.select .. "'")
		end
	
	end
	
	function ActiveRecord:from(str)
		
		if self.this.from == nil then
			
			self.this.from = str
		else
			
			self:printlog("Attenzione from gia valorizzato con '" .. self.this.from .. "'...")
		end
	end
	
	function ActiveRecord:where(campo, valore)
	
		if self.this.where == nil then
			
			self.this.where = "";
		end
		
		if self.this.where ~= "" then
				
			self.this.where = self.this.where .. " AND "
		end
		
		
		if type(valore) == "number" then
			
			self.this.where = self.this.where .. campo:gsub(operatore(campo),"") .. [[ ]] .. operatore(campo) .. [[ ]] .. valore
					
		elseif type(valore) == "string" then
			
			self.this.where = self.this.where .. campo:gsub(operatore(campo),"") .. [[ ]] .. operatore(campo) .. [[ ']] .. addslashes(valore) .. [[']]
		end
		
	end
	
	function ActiveRecord:like(campo, valore, like_type)
	
		local tipo = like_type or "both" -- both, after, before
	
		if self.this.where == nil then
			
			self.this.where = "";
		end
		
		if self.this.where ~= "" then
				
			self.this.where = self.this.where .. " AND "
		end
		
		self.this.where = self.this.where .. campo .. [[ ]] .. "LIKE"
		
		if tipo == "both" then
		
			self.this.where = self.this.where .. [[ '%]] .. addslashes(valore) .. [[%']]
		
		elseif tipo == "after" then	
		
			self.this.where = self.this.where .. [[ ']] .. addslashes(valore) .. [[%']]
		
		elseif tipo == "before" then
		
			self.this.where = self.this.where .. [[ '%]] .. addslashes(valore) .. [[']]
		end	
	end
	
	function ActiveRecord:join(table_name, join, join_type)
		
		local tabella = table_name or "N"
		local tipo    = join_type or "LEFT" -- left, right, inner
		
		tipo = string.upper(tipo)
		
		
		if tipo ~= "LEFT" and tipo ~= "RIGHT" and tipo ~= "INNER" then
			
			self:printlog("Tipologia di join non valida")
			return false
		end
		
		if tabella == "N" then
			
			self:printlog("Tabella per il join non specificata")
			return false
		end
		
		if self.this.join == nil then
			
			self.this.join = "";
		end
		
		if self.this.join ~= "" then
				
			self.this.join = self.this.join .. " "
		end
		
		self.this.join = self.this.join .. tipo .. [[ JOIN ]] .. tabella .. [[ ON ]] .. join
		
	end
	
	function ActiveRecord:group_by( campo )
		
		
		if self.this.group_by == nil then
			
			self.this.group_by = "";
		end
		
		if self.this.group_by ~= "" then
				
			self.this.group_by = self.this.group_by .. ", "
		end
		
		self.this.group_by = self.this.group_by .. campo
		
	end
	
	function ActiveRecord:order_by( campo, tipologia_order )
		
		local type = tipologia_order or ""
		
		type = string.upper(type)
		
		if type ~= "DESC" and type ~= "ASC" and type ~= "" then
			
			self:printlog("Attenzione l'ordinamento '" .. type .. "' non è supportato...")
			return false
		end
		
		if self.this.order_by == nil then
			
			self.this.order_by = "";
		end
		
		if self.this.order_by ~= "" then
				
			self.this.order_by = self.this.order_by .. ", "
		end
		
		
		if type == "" then
			
			self.this.order_by = self.this.order_by .. campo
		
		else
			
			self.this.order_by = self.this.order_by .. campo .. [[ ]] .. type
		end
	end
	
	function ActiveRecord:limit( numero_righe, riga_partenza_limit )
		
		local riga_partenza = riga_partenza_limit or nil
		
		if self.this.limit == nil then
			
			if riga_partenza == nil then
			
				self.this.limit = tostring(0) .. [[,]] .. tostring(numero_righe)
			else 
			
				self.this.limit = tostring(riga_partenza) .. [[,]] .. tostring(numero_righe)
			end
			
		else
			
			self:printlog("Attenzione limit gia valorizzato con '" .. self.this.limit .. "'...")
		end
	
	end
	
	function ActiveRecord:set( campo, valore )
		
		if type(campo) == "string" then
		
			table.insert( self.this.set, tonumber(#self.this.set)+1, {[campo] = valore})
		
		elseif type(campo) == "table" then
			
			for key,value in pairs(campo) do
				
				table.insert( self.this.set, tonumber(#self.this.set)+1, {[key] = value})
			end
		end
	end
	
	function ActiveRecord:get( table_name )
		
		local select, tblname, where, query
		
		tblname  = table_name or self.this.from or "N"
		select   = self.this.select or "*"
		join	 = self.this.join or nil
		where    = self.this.where or nil
		group_by = self.this.group_by or nil
		order_by = self.this.order_by or nil
		limit    = self.this.limit or nil
		
		if tblname == "N" then
			
			self:printlog("Non è stata specificata una tabella...")
			return false
		end
		
		query = [[SELECT ]] .. select .. [[ FROM ]] .. tblname
		
		if join ~= nil then
			
			query = query .. [[ ]] .. join
		end
		
		if where ~= nil then
			
			query = query .. [[ WHERE ]] .. where
		end
		
		if group_by ~= nil then
			
			query = query .. [[ GROUP BY ]] .. group_by
		end
		
		if order_by ~= nil then
			
			query = query .. [[ ORDER BY ]] .. order_by
		end
		
		if limit ~= nil then
			
			query = query .. [[ LIMIT ]] .. limit
		end
		
		return self:query(query)
		
	end
	
	function ActiveRecord:update( table_name )
		
		local select, tblname, where, query
		
		tblname  = table_name or self.this.from or "N"
		where    = self.this.where or nil
		
		if tblname == "N" then
			
			self:printlog("Non è stata specificata una tabella...")
			return false
	
		elseif tonumber(#self.this.set) == 0 then
		
			self:printlog("Non sono stati impostati valori di set...")
			return false
	
		end
		
		query = [[UPDATE ]] .. tblname .. [[ SET ]]
		
		for i=1, #self.this.set, 1 do 
			
			for k,v in pairs(self.this.set[i]) do
				
				if i ~= 1 then
					
					query = query .. ", "					
				end
				
				if type(v) == "number" then
			
					query = query .. k .. [[ = ]] .. v
					
				elseif type(v) == "string" then
			
					query = query .. k .. [[ = ]] .. [[']] .. addslashes(v) .. [[']]
				end
			end
		end
		
		
		if where ~= nil then
			
			query = query .. [[ WHERE ]] .. where
		end
		
		return self:query(query)
		
	end
	
	function ActiveRecord:insert( table_name )
		
		local select, tblname, query, tmp_keys, tmp_values
		
		tblname  = table_name or self.this.from or "N"
		
		if tblname == "N" then
			
			self:printlog("Non è stata specificata una tabella...")
			return false
	
		elseif tonumber(#self.this.set) == 0 then
		
			self:printlog("Non sono stati impostati valori di set...")
			return false
	
		end
		
		tmp_keys = ""
		tmp_values = ""
		
		for i=1, #self.this.set, 1 do 
			
			for k,v in pairs(self.this.set[i]) do
				
				if i ~= 1 then
					
					tmp_keys   = tmp_keys .. ","
					tmp_values = tmp_values .. ","					
				end
				
				tmp_keys = tmp_keys .. k
				
				if type(v) == "number" then
			
					tmp_values = tmp_values .. v
					
				elseif type(v) == "string" then
			
					tmp_values = tmp_values .. [[']] .. addslashes(v) .. [[']]
				end
			end
		end
		
		query = [[INSERT INTO ]] .. tblname .. [[ (]] .. tmp_keys .. [[) VALUES (]] .. tmp_values .. [[)]] 
		
		
		return self:query(query)
		
	end
	
	function ActiveRecord:delete( table_name )
		
		local select, tblname, where, query
		
		tblname  = table_name or self.this.from or "N"
		where    = self.this.where or nil
		
		if tblname == "N" then
			
			self:printlog("Non è stata specificata una tabella...")
			return false
		end
		
		query = [[DELETE FROM ]] .. tblname
		
		if where ~= nil then
			
			query = query .. [[ WHERE ]] .. where
		end
		
		return self:query(query)
		
	end
	
	function ActiveRecord:query( query )
		
		local response = {}
		
		if query == nil then
			
			self:printlog("Nessuna query è stata passata a questa funzione...")
			return false
		end
		
		
		if string.find(query, "SELECT") ~= nil then
		
			for riga in self.conn:nrows(query) do
				
				table.insert( response, #response+1, riga )
				
			end 
		else
			
			self.conn:exec( query )
		end
		
		self.this.last_query = query
		self:reset()
		
		return response
		
	end
	
	function ActiveRecord:last_query()
		
		return self.this.last_query
	end
	
	return ActiveRecord;