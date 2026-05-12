local scene = {}

local Enemy = require "scripts/objs/enemy"
local Snake = require "scripts/objs/snake"
local Path = require "scripts/objs/path"
local Apple = require "scripts/objs/apples"
	scene.apples = {}
	scene.enemy = {}
	
function scene:load(lvl, game)
	self.level = require ("levels/"..lvl)
	
	local start = self.level.start
	self.player = Snake:new(self, start.x, start.y, start.dx, start.dy, game.initalLength, game.player.functCollision)
	self.apples = {}
		table.insert(self.apples, Apple:new(self))
		
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
				end
			end
		end
	love.graphics.setCanvas()
	
	self.enemy = {}
	if self.level.enemy then
		for v, e in ipairs(self.level.enemy) do
			local enemy = Enemy:new(e.x, e.y, e.dx, e.dy, self)
			self.enemy[v] = enemy
		end
	end	
	
end

function scene:restart()
	local start = self.level.start
	self.player:load(start.x, start.y, start.dx, start.dy, self.game.initalLength, self)
end

local function getViewOffset(scene, oy)
    local WIDTH = love.graphics.getWidth()
    local HEIGHT = love.graphics.getHeight()
    local cell = state.CELL * math.min(state.scaleW, state.scaleH)
    local snake = scene.player
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
	local width = #self.level[1]
	local height = #self.level
	local scale = math.min(state.scaleW, state.scaleH)
	
	love.graphics.push()
		local ox, oy = getViewOffset(self, state.MENU_HEIGHT * state.scaleH)
		love.graphics.translate(-ox, -oy)
		love.graphics.setColor(palette[1])
		love.graphics.rectangle('fill', 0,0, width * self.cell * scale, height * self.cell * scale)	
		love.graphics.setColor(palette[2])
		love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
				
		for _, e in ipairs(self.enemy) do
			e:draw(palette[2], self.cell * scale)
		end
		for _, a in ipairs(self.apples) do
			a:draw(palette[3], self.cell * scale)
		end
		
		self.player:draw(palette[4], self.cell * scale)
	love.graphics.pop()
end

function scene:keypressed(key, control)
	self.player:control(key, control.up, control.down, control.left, control.right)
end

function scene:update(dt)
	local game = self.game
	
	for _, a in ipairs(self.apples) do
		a:update(dt)
	end
	
	if not self.game.play then return false end
	if self.game.delay % (13 - game.speed) == 0 then
		for _, e in ipairs(self.enemy) do
			e:update(dt)
		end
		self.player:update(dt, self.apples)		
		self.player:eat(self.apples, 
			function()
				local add = 20 - (20 - game.lifes[game.life])
							
				game.score = game.score + game.add_points
							
				if game.life < 6 then
					game.lifes[game.life] = 20
					game.life = game.life + 1
					game.lifes[game.life] = add
				else
					game.lifes[game.life] = 20
				end
				
				table.insert(self.apples, Apple:new(self))
			
				game.audio.eat:setPitch(0.6 + math.random(1, 80)/100)
				game.audio.eat:play()
			
				if Screens.faled.game_over[game.score/1000] then 
					Screens.faled.msg = Screens.faled.game_over[game.score/1000]
				end
			end
		)
	end	
end

function scene:getObstacles()
	local obstacles = {}
	local player = self.player
	
	for y = 1, #self.level do
		table.insert(obstacles, {})
		for x = 1, #self.level[1] do
			table.insert(obstacles[y], self.level[y][x])
		end
	end
		
	for i = 1, #player.points do
		local p = player.points[i]
		obstacles[p.y][p.x] = 1
	end
	
	return obstacles
end

return scene
