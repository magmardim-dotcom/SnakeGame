local apples = {}

function apples:add()
	local apple = {}
	local x,y = move_random()
	apple.x = x
	apple.y = y
	apple.r = 0
	apple.angle = math.pi/2
	apple.calories = 15
	
	table.insert(self, apple)
end

function apples:draw(r,g,b)
	for a = 1, #self do
		local size = cell*0.6
		local center = cell/2
		local s = self[a]
		local x,y = (s.x-1)*cell, (s.y-1)*cell
		
		love.graphics.push()
		love.graphics.setColor(r,g,b)
		love.graphics.translate(x + center, y + center)
		love.graphics.points(0,0)
		love.graphics.rotate(s.r)
		love.graphics.rectangle('fill', -size/2, -size/2, size, size)
		love.graphics.pop()
	end	
end

function apples:update(dt)
	for a = 1, #self do
		local s = self[a]
		s.r = s.r + s.angle*dt
	end
end

function move_random()
	local x = math.random(2, scene.width/cell-1)
	local y = math.random(2, scene.height/cell-1)
	
	for i = 1,#snake.points do
		local p = snake.points[i]
		
		if (p.x == x and p.y == y) or (levels[game.lvl][y][x] == 1) then
			return move_random()
		end
	end
	
	return x, y
end

return apples
