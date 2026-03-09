local game = {}
	game.play = false
	game.score = 0
	game.add_points = 10
	game.best = 0
	game.lvl = 1
	game.delay = 0
	game.speed = 6
	game.palette = 5
	game.music = 1
	game.player = false
	game.sceen = 2
	game.highscores = {
		[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0
	}
	game.hunger = true
	game.hungry = 20
	game.basic_hungry = 20
	game.life = 6
	game.max_life = 6
	game.tremor = Tremor:new(4)
	game.inital_length = 3
	game.max_apples = 1
	

function game:load()
	snake:load(5,2,self.inital_length)
	scene:load(levels[game.lvl])
	game.player = player[game.music]
end

function game:draw()

	scene:draw()

	self:draw_top_menu()
end

function game:update(dt)
	if self.delay % (13 - self.speed) == 0 then
		snake:update(dt)
	end
	
	if self.hunger then
		if self.life < 2 then
			screem:play()
		else
			screem:stop()
		end
		
		if self.hungry >= 0 then
			self.hungry = self.hungry - 4.5*dt
			if self.hungry < 10 then
				self.tremor:activate(true)
			else
				self.tremor:activate(false)
			end
		else
			self.hungry = 20
			self.life = self.life - 1
		end
	end
	
	if self.life < 1 then
		self:faled() 
		screem:stop()
	end

	apples:update(dt)	
	self.delay = self.delay + 1
	
	
	self.tremor:update(dt)
	
	if #player <= 0 then return end
	--~ if self.play then
		--~ game.player = player[game.music]
		--~ game.player:setPitch(1 + (self.speed-6)/10)
		--~ game.player:play()			
	--~ else
		--~ game.player:stop()
	--~ end
	
end

function game:faled()
	game.play = false
	game_over:play()
	
	if self.score > self.highscores[self.lvl] then
		self.highscores[self.lvl] = self.score
	end
	
	return false
end

function game:restart()
	scene:load(levels[game.lvl])
	snake:load(5, 2, self.inital_length)
	self.score = 0	
	self.play = true
	self.hungry = self.basic_hungry
	self.life = self.max_life
	screens.faled.msg = screens.faled.game_over[0]
	if #apples < self.max_apples then
		apples:add(self.max_apples - #apples)
	elseif #apples > self.max_apples then
		apples:remove(#apples - self.max_apples)
	end
	apples:reLoad()
end

function game:draw_top_menu()	
	love.graphics.push()
	love.graphics.setColor(BG_COLOR)
	love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(), MENU_HEIGHT * scaleH)
	love.graphics.setColor(0.3, 0.3, 0.3)
	
	local font = love.graphics.newFont(BASIC_FONT, 24*scaleH)
	
	love.graphics.pop()	
	love.graphics.translate(0, 10)
	love.graphics.setFont(font)
	love.graphics.print("Счет: "..tostring(self.score), 0, 0)
	if love.filesystem.getInfo("highscores.txt") then
		love.graphics.printf("Лучшее: "..tostring(self.highscores[self.lvl]), 0, 0, love.graphics.getWidth(), "right")
	end
	
	
	love.graphics.push()
		local offset = 10 * scaleW
		local siz = cell * scaleH
		
		love.graphics.translate(300 * scaleW, 2 * scaleH)
		
		for l = 1, self.life do			
			if l == self.life then self.tremor:set() end
			love.graphics.setColor(palette[game.palette][4])
			love.graphics.rectangle('fill', (l-1) * (siz + offset), 0, siz, siz)
			if l == self.life then self.tremor:unset() end
		end
		for b = 1, 6 do
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle('line', (b-1) * (siz + offset), 0, siz, siz)
		end
				
	
	love.graphics.pop()
end

return game
