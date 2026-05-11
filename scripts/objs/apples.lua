local Apple = {}
	Apple.__index = Apple

function Apple:move_random(scene)
	local w = #scene.level[1]
	local h = #scene.level	
	local x = math.random(2, w - 1)
	local y = math.random(2, h - 1)
	local obstacles = scene:getObstacles() 
			
	if (obstacles[y][x] == 1) then
		return self:move_random(scene)
	end
	
	return x, y
end

function Apple:new(scene)
	local apple = {}
		apple.x, apple.y = self:move_random(scene)	
		apple.r = 0
		apple.angle = math.pi/2
	return setmetatable(apple, self)
end

function Apple:draw(color, cell)
	local size = cell*0.6
	local center = cell/2
	local s = self
	local x,y = (s.x-1)*cell, (s.y-1)*cell
		
	love.graphics.push()
	love.graphics.setColor(color)
	love.graphics.translate(x + center, y + center)
	love.graphics.rotate(s.r)
	love.graphics.rectangle('fill', -size/2, -size/2, size, size)
	love.graphics.pop()

end

function Apple:update(dt)
	self.r = self.r + self.angle*dt
end

return Apple
