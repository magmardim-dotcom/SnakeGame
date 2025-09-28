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

function snake:draw(rgb)
	for i = 1, #self.points do
		local p = self.points[i]
		local l = 0.7/#self.points
	
		love.graphics.setColor(rgb[1],rgb[2],rgb[3],1.1-l*i)
		love.graphics.rectangle('fill', (p.x-1)*cell, (p.y-1)*cell, cell*0.9, cell*0.9)
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
	
	--~ snake:auto(apple)
	
end

function snake:eat()
	local head = self.points[1]
	
	if head.x == apple.x and head.y == apple.y then
		apple:move_random()
		game.score = game.score + game.add_points
		
		local e = game.hungry + 25
		if e < 100 then
			game.hungry = game.hungry + 25
		else
			game.hungry = 100
		end
		
		if options.game_over[game.score/1000] then 
			options.msg = options.game_over[game.score/1000]
		end
		
		return true
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

function snake:auto(apple)
	local head = self.points[1]
	
	local ax = head.x - apple.x
	local ay = head.y - apple.y
	
	local turn = function(m)
		table.insert(self.moves, m)
	end
	
		local h = self.points[1]
		local xx = {x = h.x + self.dx, y = h.y}
		local xl = {x = h.x - self.dx, y = h.y}
		local yy = {y = h.y + self.dy, x = h.x}
		local yu = {y = h.y - self.dy, x = h.x}
	
					--~ local width = scene.width/18
					--~ local height = scene.height/18

					--~ local pr = function(h)
						--~ if h.x == x and h.y == y then
							--~ return true
						--~ end
					--~ end
					
					--~ if levels[game.lvl][h.y] and levels[game.lvl][h.y][h.x + self.dx] == 1 then
						--~ if levels[game.lvl][h.y] and levels[game.lvl][h.y - self.dy][h.x] == 1 then
							--~ turn("down")
						--~ else
							--~ turn("up")
						--~ end
						--~ return
					--~ end
					--~ if levels[game.lvl][h.y + self.dy] and levels[game.lvl][h.y + self.dy][h.x] == 1 then
						--~ if levels[game.lvl][h.y] and levels[game.lvl][h.y][h.x + self.dx] == 1 then
							--~ turn("left")
						--~ else
							--~ turn("right")
						--~ end
						--~ return
					--~ end
	
	for i = 3, #self.points do
		local p = self.points[i]
					
		local pr = function(h)
			if h.x == p.x and h.y == p.y then
				return true
			end
		end
		
		if pr(xx) then
			if not pr(yy) then
				turn("down")
			else
				turn("up")
			end
			return
		end
		
		if pr(yy) then
			if not pr(xx) then
				turn("left")
			else
				turn("right")
			end
			return
		end
		
	end
	
	local proverka = function(x, y)
		local pr = function(x,y,p)
			if x == p.x and y == p.y then
				return true
			end
		end
		for i = 3, #self.points do
			local p = self.points[i]
			
			if pr(x, y, p) then
				print "body"
				return true
			end
		end
		
		--~ local width = scene.width/18
		--~ local height = scene.height/18
		--~ for yy = 1, height do
			--~ for xx = 1, width do
				--~ local p = {x = xx, y = yy}
				
				--~ if levels[game.lvl][y][x] == 1  then
					--~ print "wall"
					--~ return true
				--~ end
			--~ end
		--~ end
		return false
	end
		
	if head.y == apple.y then
		if ax > 0 and not proverka(h.x - 1, h.y) then
			turn("left")
		elseif ax < 0 and not proverka(h.x + 1, h.y) then
			turn("right")
		end		
	end
	if head.x == apple.x then
		if ay > 0 and not proverka(h.x, h.y - 1) then
			turn("up")
		elseif ay < 0 and not proverka(h.x, h.y + 1) then
			turn("down")
		end
	end
	
	--~ if h.x - apple.x > 0 and not proverka(h.x - 1, h.y) then
		--~ turn("left")
	--~ elseif h.x - apple.x < 0 and not proverka(h.x + 1, h.y) then
		--~ turn("right")
	--~ end
	--~ if h.y - apple.y > 0 and not proverka(h.x, h.y - 1) then
		--~ turn("up")
	--~ elseif h.y - apple.y < 0 and not proverka(h.x, h.y + 1) then
		--~ turn("down")
	--~ end
	
end

return snake
