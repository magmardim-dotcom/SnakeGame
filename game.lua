local game = {}
	game.play = false
	game.score = 0
	game.add_points = 100
	game.best = 0
	game.lvl = 1
	game.delay = 0
	game.speed = 4
	game.palette = 3
	game.highscores = {
		[1] = 100, [2] = 0, [3] = 0, [4] = 0, [5] = 0, 
	}
	game.hungry = 100
	game.tremor = Tremor:new(1)

function game:load()
	apple:load()
	snake:load(8,9,4)
	
end

function game:update(dt)
	if self.delay % (18 - self.speed) == 0 then
	--~ if self.delay % 1 == 0 then
		snake:update(dt)
	end
	
	if self.hungry > 0 then
		self.hungry = self.hungry - .08
	else
		self:faled()
	end
	
	if self.hungry < 40 then
		self.tremor:activate(true)
	else
		self.tremor:activate(false)
	end
	
	apple:update(dt)	
	self.delay = self.delay + 1
	
	self.tremor:update(dt)
end

function game:faled()
	game.play = false
	
	if self.score > self.highscores[self.lvl] then
		self.highscores[self.lvl] = self.score
	end
	
	return false
end

function game:restart()
	snake:load(8,9,4)
	self.score = 0	
	self.play = true
	self.hungry = 100
	options.msg = options.game_over[0]
	apple:load()
end

function game:draw_top_menu()	
	love.graphics.push()
	love.graphics.setColor(0.3, 0.3, 0.3)
	love.graphics.translate(0, 0)
	love.graphics.print("Счет: "..tostring(self.score), 0, 0)
	if love.filesystem.getInfo("highscores.txt") then
		love.graphics.printf("Лучшее: "..tostring(self.highscores[self.lvl]), 0, 0, love.graphics.getWidth(), "right")
	end
	love.graphics.setColor(palette[game.palette][4])
	
	self.tremor:set()
	love.graphics.rectangle('fill', 120*scaleW, 2*scaleH, 3.6*self.hungry*scaleW, 20*scaleH)
	self.tremor:unset()
	love.graphics.pop()
end

return game
