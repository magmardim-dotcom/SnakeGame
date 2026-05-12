local Snake = {}
	Snake.__index = Snake

function Snake:new(scene, x, y, dx, dy, size, fc)
	local snake = {}
		snake.x = x 
		snake.y = y
		snake.dx = dx
		snake.dy = dy
		snake.scene = scene
		snake.moves = {}
		snake.points = {}
			for i = 1, size do table.insert(snake.points, {x = x - i*dx, y = y}) end
		snake.path = {}
		snake.functCollision = fc or function() end
			
	return setmetatable(snake, self)
end

function Snake:load(x, y, dx, dy, size, scene) 
	self.x = x 
	self.y = y
	self.dx = dx
	self.dy = dy
	self.scene = scene
	self.moves = {} 
	self.points = {}
		for i = 1, size do table.insert(self.points, {x = x - i*dx, y = y}) end 
	
	return true
end

function Snake:draw(color, cell)
	for i = 1, #self.points do
		local p = self.points[i]
		local l = 0.7/#self.points
		
		love.graphics.push()
			love.graphics.setColor(color[1],color[2],color[3],1.1-l*i)
			love.graphics.rectangle('fill', (p.x-1)*cell, (p.y-1)*cell, cell*0.9, cell*0.9)
		love.graphics.pop()
	end
end

function Snake:update(dt, apples)
	if not self:collision() then
		self:move(apples)
	end
	
	if self.moves[1] then
		local dx, dy = self.dx, self.dy
		local key = self.moves[1]
		
		if key == 'up' and self.dy ~= 1 then
			dy = -1
			dx = 0
		elseif key == 'down' and self.dy ~= -1 then
			dy = 1
			dx = 0
		elseif key == 'left' and self.dx ~= 1 then
			dx = -1
			dy = 0
		elseif key == 'right' and self.dx ~= -1 then
			dx = 1
			dy = 0
		end	
		
		self.dx = dx
		self.dy = dy
		
		table.remove(self.moves, 1)
	end
	
end

function Snake:move(apples)
	local head = self.points[1]
	local w = #self.scene.level[1]
	local h = #self.scene.level	
	local x = head.x + self.dx
	local y = head.y + self.dy
		
	if head.x + self.dx - 1 < 0 then
		x = w
	elseif head.x + self.dx > w then
		x = 1
	end
	
	if head.y + self.dy - 1 < 0 then
		y = h
	elseif head.y + self.dy > h then
		y = 1	
	end
	
	table.insert(self.points, 1, {x = x, y = y})
end

function Snake:eat(apples, funct)
	local head = self.points[1]
		
	for n, s in ipairs(apples) do
		if head.x == s.x and head.y == s.y then
			
			table.remove(apples, n)
				funct()		
			return true
		end
	end
	
	table.remove(self.points)
	return false
end

function Snake:control(key, up, down, left, right)
	if #self.moves > 2 then return end
	
	--~ if key == self.keys.up or key == self.keys.down or key == self.keys.left or key == self.keys.right then
	if key == up or key == down or key == left or key == right then
	
		local move = ""
		
		if key == up then
			move = "up"
		elseif key == down then
			move = "down"
		elseif key == left then
			move = "left"
		elseif key == right then
			move = "right"
		end
		
		table.insert(self.moves, move)
	
	end
end

function Snake:collision()
	local head = self.points[1]
	local scene = self.scene 
	
	for i = 2, #self.points do
		local p = self.points[i]
		if head.x + self.dx == p.x and head.y + self.dy == p.y then
			self.functCollision()
			return true
		end
	end

	local level = scene.level
	
	if level[head.y + self.dy] and level[head.y + self.dy][head.x + self.dx] == 1 then
		self.scene.game:faled()
		return true
	end
	
	return false
end

return Snake
