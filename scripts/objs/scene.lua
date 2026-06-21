local scene = {}

local Enemy = require "scripts/objs/enemy"
local Snake = require "scripts/objs/snake"
local Apple = require "scripts/objs/apples"
	scene.apples = {}
	scene.enemy = {}
	
function scene:load(lvl, game)
	self.level = require ("levels/"..lvl)
	self.level.enemy = {}
	
	local start = self.level.start
	self.game.player.snake = Snake:new(self, start.x, start.y, start.dx, start.dy, game.initalLength, game.player.functCollision)
	self.player1.snake = Snake:new(self, 13, 15, 1, 0, 7, self.player1.functCollision)
	self.player2.snake = Snake:new(self, 42, 15, -1, 0, 7, self.player2.functCollision)
			
	local lvlW, lvlH = #self.level[1], #self.level
	self.cell = state.CELL

	self.canvas = love.graphics.newCanvas(lvlW * self.cell, lvlH * self.cell)
	love.graphics.setCanvas(self.canvas)
		love.graphics.setColor(1,1,1)
		for y = 1, lvlH do
			for x = 1, lvlW do
				local b = self.level[y][x]
				if b == 1 then
					local x,y = (x-1)*self.cell, (y-1)*self.cell

					love.graphics.rectangle('fill', x, y, self.cell, self.cell)
				elseif b > 1 then
					local ed = {
						[3] = {dx = 1, dy = 0},
						[4] = {dx = -1, dy = 0},
						[5] = {dx = 0, dy = -1},
						[6] = {dx = 0, dy = 1},
					}
					local enemy = {x = x, y = y, dx = ed[b].dx, dy = ed[b].dy}
					table.insert(self.level.enemy, enemy)
				end
			end
		end
	love.graphics.setCanvas()
end

function scene:restart(mode, m)
	self.enemy = {}
	self.apples = {}
	self.m = m
	
	if mode == "game" then
		local start = self.level.start
				
		self.game.player.snake = Snake:new(self, start.x, start.y, start.dx, start.dy, self.game.initalLength, self.game.player.functCollision)
		table.insert(self.apples, Apple:new(self, true))
		table.insert(self.apples, Apple:new(self, false))
		
		if self.level.enemy then
			for v, e in ipairs(self.level.enemy) do
				local enemy = Enemy:new(e.x, e.y, e.dx, e.dy, self)
				self.enemy[v] = enemy
			end
		end
	elseif mode == "fight" then
		scene.player1.snake = Snake:new(scene, 8, 8, 1, 0, self.game.initalLength, scene.player1.functCollision)		
		scene.player2.snake = Snake:new(scene, 38, 23, -1, 0, self.game.initalLength, scene.player2.functCollision)
		
		table.insert(self.apples, Apple:new(self, true, 16, 8))
		table.insert(self.apples, Apple:new(self, true, 31, 23))
		scene.player1.snake:findApples()
		scene.player2.snake:findApples()
	end
end

local function getViewOffset(scene, oy)
    local WIDTH = love.graphics.getWidth()
    local HEIGHT = love.graphics.getHeight()
    local cell = state.CELL * math.min(state.scaleW, state.scaleH)
    local snake = scene.game.player.snake
    local game = scene.game
    
    local headX = snake.points[1].x * cell
    local headY = snake.points[1].y * cell

    local halfW = WIDTH  / 2
    local halfH = HEIGHT / 2
	
	local map = scene.level
    local mapW = #map[1] * cell
    local mapH = #map * cell

    local offsetX = headX - halfW
    local offsetY = headY - halfH
    
    offsetX = math.max(0, math.min(offsetX, mapW - WIDTH))
    offsetY = math.max(0, math.min(offsetY, mapH - HEIGHT + oy))

    return offsetX, offsetY
end

function scene:draw(palette) 	
	local scale = math.min(state.scaleW, state.scaleH)
	local width = #self.level[1] * scale * state.CELL
	local height = #self.level * scale * state.CELL
	
	love.graphics.push()
		local ox, oy = getViewOffset(self, state.MENU_HEIGHT * state.scaleH)
		love.graphics.setColor(palette[1])
		love.graphics.rectangle('fill', 0,0, width, height)
		
		love.graphics.translate(-ox, -oy)	
		love.graphics.setColor(palette[3][1], palette[3][2], palette[3][3], 0.02)
		love.graphics.setLineWidth(1*scale)
		love.graphics.setLineStyle("rough")
		for y = 1, #self.level do
			for x = 1, #self.level[1] do
				love.graphics.rectangle('line', (x-1) * scale * state.CELL, (y-1) * scale * state.CELL, self.cell * scale, self.cell * scale)
			end
		end		
		love.graphics.setColor(palette[2])
		love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
		
		for _, e in ipairs(self.enemy) do
			e:draw(palette[2], self.cell * scale)
		end
			
		for _, a in ipairs(self.apples) do
			a:draw(palette[3], self.cell * scale)
		end
			
		if self.game.mode == "game" then	
			self.game.player.snake:draw(palette[4], self.cell * scale)
		elseif self.game.mode == "fight" then
			self.player1.snake:draw(palette[4], self.cell * scale)
			self.player2.snake:draw(palette[3], self.cell * scale)
		end
	love.graphics.pop()
end

function scene:keypressed(key, control)
	if self.game.mode == "game" then
		self.game.player.snake:control(key, control.up, control.down, control.left, control.right)
	elseif self.game.mode == "fight" then
		local player1 = self.player1
		local player2 = self.player2
		
		player1.snake:control(key, player1.control.up, player1.control.down, player1.control.left, player1.control.right)
		player2.snake:control(key, player2.control.up, player2.control.down, player2.control.left, player2.control.right)
	end
end

function scene:update(dt)
	local game = self.game
	
	for _, a in ipairs(self.apples) do
		a:update(dt)
	end
	
	if not self.game.play then return false end	
	if game.mode == "game" then
		local player = self.game.player.snake
				
		
		if self.game.delay % (13 - game.speed) == 0 then
						
			player:update(dt, true)	
			
			if player:damageCollision() then
				game.shake:start(0.1, 1, 1)
				game:getDamage()
			end
					
			for _, e in ipairs(self.enemy) do
				e:update(dt, player)
			end	
			
			if player:damageCollision() then
				game.shake:start(0.1, 1, 1)
				game:getDamage()
			end
			
			if player:eat(self.apples) then 
				local add = 20 - (20 - game.lifes[game.life])
				
				--~ player:findApples()				
				game.score = game.score + game.add_points
								
				if game.life < 6 then
					game.lifes[game.life] = 20
					game.life = game.life + 1
					game.lifes[game.life] = add
				else
					game.lifes[game.life] = 20
				end
				self.apples[1]:act()
				table.insert(self.apples, Apple:new(self, false))
				
				game.audio.eat:play()
				
				if Screens.faled.game_over[game.score/1000] then 
					Screens.faled.msg = Screens.faled.game_over[game.score/1000]
				end
			end
		end	
	elseif game.mode == "fight" then
		if self.game.delay % (13 - game.speed) == 0 then
			local player1 = self.player1.snake
			local player2 = self.player2.snake
			player2:update(dt, self.m > 1)
			player1:update(dt, self.m > 2)
			
			if player2:eat(self.apples) then
				table.insert(self.apples, Apple:new(self, true))
				local sound = game.audio.eat:clone()
				sound:setPitch(math.random(6,12) * 0.1)
				sound:play()			
			end
			
			if player1:eat(self.apples) then
				table.insert(self.apples, Apple:new(self, true))
				local sound = game.audio.eat:clone()
				sound:setPitch(math.random(6,12) * 0.1)
				sound:play()
			end	
			
								
		end
	end
	
end

function scene:getObstacles()
	local obstacles = {}
	local player = self.game.player.snake
	
	for y = 1, #self.level do
		table.insert(obstacles, {})
		for x = 1, #self.level[1] do
			table.insert(obstacles[y], self.level[y][x])
		end
	end
	
	if self.game.mode == "game" then
		for i = 1, #player.points do
			local p = player.points[i]
			obstacles[p.y][p.x] = 1
		end
	elseif self.game.mode == "fight" then
		local player1 = self.player1.snake
		local player2 = self.player2.snake
		
		for i = 1, #player1.points do
			local p = player1.points[i]
			obstacles[p.y][p.x] = 1
		end
		for i = 1, #player2.points do
			local p = player2.points[i]
			obstacles[p.y][p.x] = 1
		end
	
	end
	
	return obstacles
end

return scene
