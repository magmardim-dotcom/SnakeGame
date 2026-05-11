local dbg = {}
	dbg.font = love.graphics.newFont(10)

function dbg:getStatus()
	local stats = love.graphics.getStats()
	local fps = tostring(love.timer.getFPS())
	local memory = string.format('%.0f', tostring(collectgarbage('count')))
	local w, h = love.graphics.getDimensions() 
	
	return ("FPS: " .. fps .. "\n" ..
			"Memory: "..memory .. "\n" ..
			"Draw Calls: " .. stats.drawcalls .. "\n" ..
			"Textures: " .. stats.images .. "\n" ..
			"Texture Mem: " .. math.floor(stats.texturememory / 1024) .. " KB" .. "\n" ..
			"Fonts: " .. stats.fonts .. "\n" ..
			"Canvas: " .. stats.canvases .. "\n"..
			"Width: "..w.." Height: "..h
			)
end

function dbg:draw(x, y)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.setColor(0, 1, 0)
	love.graphics.setFont(self.font)
	love.graphics.print(
		self:getStatus(),
		10, 10
		)
	love.graphics.pop()
end

return dbg
