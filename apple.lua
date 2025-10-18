local apple = {}
	
function apple:load()
	apple.x = 0
	apple.y = 0
	apple.r = 0
	apple.angle = math.pi/2
	self:move_random()
	apple.calories = 25
end

function apple:draw(r,g,b)
	local size = cell*0.6
	local center = cell/2
	local x,y = (self.x-1)*cell, (self.y-1)*cell
	
	love.graphics.push()
	love.graphics.setColor(r,g,b)
	love.graphics.translate(x + center, y + center)
	love.graphics.points(0,0)
	love.graphics.rotate(self.r)
	love.graphics.rectangle('fill', -size/2, -size/2, size, size)
	love.graphics.pop()
end

function apple:update(dt)
	self.r = self.r + self.angle*dt
end

function apple:move_random()
	local x = math.random(2, scene.width/cell-1)
	local y = math.random(2, scene.height/cell-1)
	
	for i = 1,#snake.points do
		local p = snake.points[i]
		
		if (p.x == x and p.y == y) or (levels[game.lvl][y][x] == 1) then
			return apple:move_random()
		end
	end
	
	self.x = x 
	self.y = y
	
	return true
end

return apple
