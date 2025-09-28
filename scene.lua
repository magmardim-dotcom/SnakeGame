local scene = {}
	scene.width = 630
	scene.height = 324
	scene.tremor = Tremor:new(3)

function scene:draw()
	local level = levels[game.lvl] 
	local pal = palette[game.palette]
	
	love.graphics.push()	
		self.tremor:set()
		love.graphics.setColor(pal[1])
		love.graphics.translate(5, 26)
		love.graphics.rectangle('fill', 0,0,self.width,self.height)
		
		local width = scene.width/18
		local height = scene.height/18
		
		love.graphics.setColor(pal[2])
		for y = 1, height do
			for x = 1, width do
				local b = level[y][x]
				if b == 1 then
					love.graphics.rectangle('fill', (x-1)*cell, (y-1)*cell, cell, cell)
				end
			end
		end
				
		apple:draw(pal[3])
		snake:draw(pal[4])
		self.tremor:unset()
	love.graphics.pop()
end

function scene:update(dt)
	self.tremor:update(dt)
end

return scene
