local Enemy = {}
	Enemy.__index = Enemy

function Enemy:new(x, y, dx, dy, scene)
	local enemy = {}
		enemy.x = x
		enemy.y = y
		enemy.dx = dx
		enemy.dy = dy
		enemy.r = 0
		enemy.scene = scene
			
	return setmetatable(enemy, self)
end

function Enemy:draw(color, cell)
	local size = cell
	local center = size/2
	local s = self
	local x,y = (s.x-1) * size, (s.y-1) * size
	
	love.graphics.push()
		love.graphics.setColor(color)
		love.graphics.translate(x + center, y + center)
		love.graphics.rotate(s.r)
		love.graphics.rectangle('fill', -size/2, -size/2, size, size)
	love.graphics.pop()
end

function Enemy:update(dt, speed)
	--~ self.r = self.r + dt*speed
	--~ rx = math.random(10)
	--~ ry = math.random(10)
	
	if rx == 1 then self.dx = 0 self.dy = math.random(-1, 1) end
	if ry == 1 then self.dy = 0 self.dx = math.random(-1, 1) end
	
	local level = self.scene.level
	local y = (self.dy > 0 and math.floor(self.y) or math.ceil(self.y)) + self.dy
	local x = (self.dx > 0 and math.floor(self.x) or math.ceil(self.x)) + self.dx
	
	if level[math.floor(self.y)] and level[math.floor(self.y)][x] == 1 then
		self.dx = -self.dx
	else
		self.x = self.x + self.dx * dt * speed
	end
	
	if level[y] and level[y][math.floor(self.x)] == 1 then
		self.dy = -self.dy
	else
		self.y = self.y + self.dy * dt * speed
	end	
end

function Enemy:move()
	
end


return Enemy
