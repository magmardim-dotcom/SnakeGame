local Enemy = {}
	Enemy.__index = Enemy

function Enemy:new(x, y, dx, dy, scene)
	local enemy = {}
		enemy.x = x
		enemy.y = y
		enemy.dx = dx
		enemy.dy = dy
		enemy.scene = scene
		enemy.last = {}
			
	return setmetatable(enemy, self)
end

--~ function Enemy:draw(color, cell)
	--~ local size = cell
	--~ local center = size/2
	--~ local s = self
	--~ local x,y = (s.x-1) * size, (s.y-1) * size
	
	--~ love.graphics.push()
		--~ love.graphics.setColor(color)
		--~ love.graphics.translate(x + center, y + center)
		--~ love.graphics.rotate(s.r)
		--~ love.graphics.rectangle('fill', -size/2, -size/2, size, size)
	--~ love.graphics.pop()
--~ end

function Enemy:draw(color, cell)
	local size = cell
	local s = self
	local x,y = (s.x-1) * size, (s.y-1) * size
	
	love.graphics.push()
		love.graphics.setColor(color)
		love.graphics.rectangle('fill', x, y, size, size)
		
		
		for v, l in ipairs(self.last) do
			love.graphics.setColor(color[1], color[2], color[3], l.a)
			love.graphics.rectangle('fill', (l.x-1) * size, (l.y-1) * size, size, size)
			l.a = l.a - (.01 * self.scene.game.speed)
			if l.a <= 0 then table.remove(self.last, v) end
		end
	love.graphics.pop()
end

--~ function Enemy:update(dt, speed)	
	--~ local level = self.scene.level
	--~ local y = (self.dy > 0 and math.floor(self.y) or math.ceil(self.y)) + self.dy
	--~ local x = (self.dx > 0 and math.floor(self.x) or math.ceil(self.x)) + self.dx
	
	--~ if level[math.floor(self.y)] and level[math.floor(self.y)][x] == 1 then
		--~ self.dx = -self.dx
	--~ else
		--~ self.x = self.x + self.dx * dt * speed
	--~ end
	
	--~ if level[y] and level[y][math.floor(self.x)] == 1 then
		--~ self.dy = -self.dy
	--~ else
		--~ self.y = self.y + self.dy * dt * speed
	--~ end	
--~ end

function Enemy:update(dt, snake)
    local level = self.scene.level
    local nextX = self.x + self.dx
    local nextY = self.y + self.dy
    
    table.insert(self.last, {x = self.x, y = self.y, a = 1})

    if level[self.y] and level[self.y][nextX] == 1 then
        self.dx = -self.dx
    end
    
    if level[nextY] and level[nextY][self.x] == 1 then
        self.dy = -self.dy
    end
    
    self.x, self.y = nextX, nextY 
end


function Enemy:move()
	
end


return Enemy
