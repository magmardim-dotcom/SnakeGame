local snake = {}
	snake.points = {}
	snake.moves = {}

function snake:load(x,y,size)
	self.points = {}
	self.x = x
	self.y = y
	self.dx = 1
	self.dy = 0
	self.moves = {}
	self.keys = {
		up = "w",
		down = "s",
		right = "d",
		left = "a"
	}
	
	for i = 1, size do
		table.insert(self.points, {x = x - i, y = y})
	end
end

function snake:draw(rgb, cell)
	for i = 1, #self.points do
		local p = self.points[i]
		local l = 0.7/#self.points
		
		love.graphics.push()
			love.graphics.setColor(rgb[1],rgb[2],rgb[3],1.1-l*i)
			if game.sceen == 1 then
				love.graphics.translate(cell/2, cell/2)
				love.graphics.circle('fill', (p.x-1)*cell, (p.y-1)*cell, cell*0.45)
			elseif game.sceen == 2 then
				love.graphics.rectangle('fill', (p.x-1)*cell, (p.y-1)*cell, cell*0.9, cell*0.9)
			elseif game.sceen == 3 then
				if i == 1 then
					
				else
					love.graphics.translate(cell/2, cell/2)
					love.graphics.circle('fill', (p.x-1)*cell, (p.y-1)*cell, cell*0.45)
				end
			end
		love.graphics.pop()
	end
end

function snake:update(dt)
	if not self:collision() then
		self:move()
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

function snake:move()
	local head = self.points[1]
	local w, h = (scene.width/cell), (scene.height/cell)
	
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
	if not self:eat() then
		table.remove(self.points)
	end
	
end

function snake:eat()
	local head = self.points[1]
	
	for a = 1, #apples do
		local s = apples[a]
		if head.x == s.x and head.y == s.y then
			local x, y = apples:move_random()
			s.x, s.y = x, y
			game.score = game.score + game.add_points * (11 - #apples)
			
			game.hungry = 20
			if game.life < 6 then
				game.life = game.life + 1
			end
			
			eat:setPitch(0.6 + math.random(1, 80)/100)
			eat:play()
			
			if screens.faled.game_over[game.score/1000] then 
				screens.faled.msg = screens.faled.game_over[game.score/1000]
			end
			
			return true
		end
	end
	return false
end

function snake:control(key)
	if #self.moves > 2 then return end
	
	if key == self.keys.up or key == self.keys.down or key == self.keys.left or key == self.keys.right then
	
		local move = ""
		
		if key == self.keys.up then
			move = "up"
		elseif key == self.keys.down then
			move = "down"
		elseif key == self.keys.left then
			move = "left"
		elseif key == self.keys.right then
			move = "right"
		end
		
		table.insert(self.moves, move)
	
	end
end

function snake:collision()
	local head = self.points[1]
	
	for i = 2, #self.points do
		local p = self.points[i]
		if head.x + self.dx == p.x and head.y + self.dy == p.y then
			game:faled()
			scene.tremor:activate(true, 10)
			return true
		end
	end
	
	local width = scene.width/18
	local height = scene.height/18
	local level = levels[game.lvl]
	
	if level[head.y + self.dy] and level[head.y + self.dy][head.x + self.dx] == 1 then
		game:faled()
		scene.tremor:activate(true, 10)
		return true
	end
	
	return false
end



return snake
