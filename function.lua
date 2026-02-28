function load_music(folder)
	local music = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do
		local item = love.audio.newSource(folder.."/"..v, "static")	

		table.insert(music, item)
	end
	
	return music
end

function load_levels(folder)
	local levels = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do	
		local i = string.find(v, "%.")		
		local item = require (folder.."/"..(string.sub(v, 1, i-1)))	

		table.insert(levels, item)
	end
	
	return levels
end

function scaler()
	local width, height = love.window.getDesktopDimensions()
	
	return width/def_width, height/def_height
end

function SetFullscreenMode(boolean)
	if boolean then
		love.window.setFullscreen(true)
		scaleW, scaleH = scaler()
		love.graphics.setFont(font_fullscreen)
	else
		love.window.setFullscreen(false)
		scaleW, scaleH = 1, 1
		love.graphics.setFont(font)
	end
end
