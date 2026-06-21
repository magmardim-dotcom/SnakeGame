local Path = require "scripts/modules/Path"
local Vector = require "scripts/modules/Vector"

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
		snake.functCollision = fc or function() end
		snake.apple = 1
		
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
			love.graphics.translate(cell*0.1, cell*0.1)
			love.graphics.setLineWidth(2)
			if i > 1 then				
				love.graphics.rectangle('fill', (p.x-1)*cell, (p.y-1)*cell, cell*0.8, cell*0.8)
			else
				love.graphics.rectangle('line', (p.x-1)*cell, (p.y-1)*cell, cell*0.8, cell*0.8)
			end
		love.graphics.pop()
	end
	if self.path then self.path:draw({1,0,0,.1}, cell) end
end

function Snake:update(dt, cpu)
	local o = self.scene:getObstacles()
	
	if cpu then self:cpu(o)end
	
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
	
	if not self:collision(o) then
		self:move()
	end
end

function Snake:move()
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
	
	table.insert(self.points, 1, {x = x, y = y, fat = false})
end

function Snake:eat(apples)
	local head = self.points[1]
		
	for n, s in ipairs(apples) do
		if head.x == s.x and head.y == s.y and s.activate then
			table.remove(apples, n)		
			return true
		end
	end
	
	table.remove(self.points)
	return false
end

function Snake:control(key, up, down, left, right)
	if #self.moves > 2 then return end
	
	if key == up or key == down or key == left or key == right then
	
		local move = ""
		local head = self.points[1]
		
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

function Snake:collision(o)
	local head = self.points[1]

	local level = o 
	local nx, ny = head.x + self.dx, head.y + self.dy
	
	if level[ny] and level[ny][nx] == 1 then
		self.functCollision()
		return true
	end
	
	return false
end

function Snake:damageCollision()
	local head = self.points[1]
	local enemy = self.scene.enemy
	
	for _, e in ipairs(enemy) do
		if head.x == e.x and head.y == e.y then
			return true
		end
	end
	
	return false
end

function Snake:cpu(map)
	local head = self.points[1]
	local apples = self.scene.apples
	self:findApples()
	self.path = Path:new(head.x, head.y, map)
	self.path:search(apples[self.apple].x, apples[self.apple].y)
	
	self.moves = self.path.moves or {}
end

function Snake:findApples()
	local head = self.points[1]
	local apples = self.scene.apples
	local minl = Vector:new(apples[1].x - head.x, apples[1].y - head.y):getLenght()
	local ak = 1
	for k, a in ipairs(apples) do 
		if a.activate then
			local vec = Vector:new(a.x - head.x, a.y - head.y)
			if vec:getLenght() < minl then
				minl = vec:getLenght() 
				ak = k
			end
		end
	end
	self.apple = ak
end

return Snake
