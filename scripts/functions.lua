local funct = {}

function funct.loadScripts(folder)
	local scripts = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for _,item in ipairs(items) do
		local item = string.match(item, "%a+")
		local s = folder.."/"..item
		
		scripts[item] = require (s)
	end
	
	return scripts
end

function funct.loadMusic(folder)
	local music = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do
		local item = love.audio.newSource(folder.."/"..v, "static")	

		table.insert(music, item)
	end
	
	return music
end

function funct.loadLevels(folder)
	local levels = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do	
		local i = string.find(v, "%.")		
		local item = string.sub(v, 1, i-1)	

		table.insert(levels, item)
	end
	
	return levels
end


function funct.scaler(base_w, base_h, new_w, new_h)
	return new_w/base_w, new_h/base_h
end

function funct.switchScreen(to)
	curScreen = to
	return true
end

return funct
