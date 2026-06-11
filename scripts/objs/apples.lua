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

function Apple:new(scene, act, x, y)
	local apple = {}
		if not x or not y then
			apple.x, apple.y = self:move_random(scene)
		else
			apple.x, apple.y = x, y
		end	
		apple.r = 0
		apple.angle = math.pi/2
		apple.activate = act
	return setmetatable(apple, self)
end

function Apple:draw(color, cell)
	local size = cell*0.6
	local center = cell/2
	local s = self
	local x,y = (s.x-1)*cell, (s.y-1)*cell
	local scale = math.min(state.scaleW, state.scaleH)
		
	love.graphics.push()	
	love.graphics.translate(x + center, y + center)
	love.graphics.rotate(s.r)
	if self.activate then
		love.graphics.setColor(color)
		love.graphics.rectangle('fill', -size/2, -size/2, size, size)
	else
		love.graphics.setLineWidth(2 * scale)
		love.graphics.setColor(color[1], color[2], color[3], 0.5)
		love.graphics.rectangle('line', -size/2, -size/2, size, size)
	end
	love.graphics.pop()

end

function Apple:update(dt)
	self.r = self.r + self.angle*dt
end

function Apple:act()
	self.activate = true
	
	return true
end

return Apple
