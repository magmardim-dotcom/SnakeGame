local game = {}
		
function game:load()
	self.scene = require "scripts/objs/scene"
	self.scene.game = self
	self.mode = "game"
	self.levels = funct.loadLevels("levels")	
	self.play = false
	self.delay = 0
	self.score = 0
	self.add_points = 100
	self.best = 0	
	self.speed = 5		
	self.highscores = {}	
		for l = 1, #self.levels do self.highscores[l] = 0 end
	self.hunger = false
	self.life = 6
	self.max_life = 6
	self.lifes = {}
		for l = 1, self.max_life do self.lifes[l] = 20 end
	self.initalLength = 4
	self.max_apples = 1
	
	self.lvl = 3
	self.font = love.graphics.newFont(state.BASIC_FONT, state.FONT2_SIZE, "normal", 2)
	
	self.player = {}
	self.player.control = {
		up = "w", down = "s", left = "a", right = "d"
	}
	self.player.functCollision = function() self:faled() end
			
	if love.filesystem.getInfo("highscores.txt") then
		local l = 1
		
		for lines in love.filesystem.lines("highscores.txt") do
			self.highscores[l] = tonumber(lines)
			l = l + 1
		end
	end	
	
	self.audio = {
		eat = Audio['eat.ogg'],
		over = Audio['end.ogg'],
		damage = Audio['damage.ogg']
	}
	self.music = Music["track1.ogg"]
	love.audio.setEffect("reverb", {type="reverb", diffusion = 1, density = 1, gain = 1, roomrolloff = 10})
	love.audio.setVolume(state.musicVol)
	
	self.shake = Modules.Shake
	
	self.getDamage = function()
		self.audio.damage:play()
		if self.life > 1 then
			local damage = 20 - self.lifes[self.life]
			self.life = self.life - 1
			self.lifes[self.life] = self.lifes[self.life] - damage
		else
			self:faled()
			self.life = 1
			self.lifes[self.life] = 0
		end
	end
		
	self:sceneLoad(self.lvl)
end

function game:sceneLoad(lvl)
	self.scene:load(self.levels[lvl], self)	
	for l = 1, self.max_life do self.lifes[l] = 20 end
	self.life = self.max_life
	Screens.faled.msg = Screens.faled.game_over[0]
end

function game:playMusic()
	if state.musicPlay then
		self.music:setLooping(true)
		self.music:play()
	end
end

function game:stopMusic()
	self.music:stop()
end

function game:draw(palette)
	local level = self.levels[self.lvl] 
	local scale = math.min(state.scaleW, state.scaleH)
	local widthScene = #self.scene.level[1] * state.CELL * scale
	local heightScene = #self.scene.level * state.CELL * scale
	local indentX = widthScene <= love.graphics.getWidth() and (love.graphics.getWidth() - widthScene)/2 or 0
	
	local indentY = state.MENU_HEIGHT * state.scaleH

	love.graphics.push()
	love.graphics.translate(indentX, indentY)
	self.shake:push()
	self.scene:draw(palette)
	self.shake:pop()
	love.graphics.pop()
	
	self:drawTopMenu(palette)
end

function game:update(dt)
	self.scene:update(dt)
	self.shake:update(dt)
	
	if not self.play then return false end	
	
	if self.hunger then		
		if self.lifes[self.life] >= 0 then
			self.lifes[self.life] = self.lifes[self.life] - 4.5*dt
		else
			self.life = self.life - 1
		end
	end
	
	if self.life < 1 then
		self:faled()
	end
	
	self.delay = self.delay + 1
end

function game:faled()
	game.play = false
	self.music:setVolume(.4)
	self.music:setEffect("reverb", true)
	self.audio.over:play()
	
	if self.score > self.highscores[self.lvl] then
		self.highscores[self.lvl] = self.score
	end
	
	self.shake:start(0.5, 10, 3)
	
	return false
end

function game:restart(mode)	
	local apples = self.scene.apples
	
	self.scene:restart(mode)
	self.score = 0	
	self.play = true
	for l = 1, self.max_life do self.lifes[l] = 20 end
	self.life = self.max_life
	Screens.faled.msg = Screens.faled.game_over[0]	
	
	self.music:setVolume(1)
	self.music:setEffect("reverb", false)
end

function game:keypressed(key, down, up, right, left)
	self.scene:keypressed(key, self.player.control)
end

function game:quit()
	local best = ""
	
	for _, h in ipairs(self.highscores) do
		best = best..tostring(h).."\n"
	end
	
	love.filesystem.write( "highscores.txt", best)
end

function game:drawTopMenu(palette, font)	
	local scaleW, scaleH = state.scaleW, state.scaleH
	local scale = math.min(scaleW, scaleH)
	local indentX = 50
	local indentY = (state.MENU_HEIGHT - self.font:getHeight())/2
	local menuX = 20 * scale
	local menuY = 2 * scale
	
	love.graphics.push()
	love.graphics.setColor(palette[1])
	love.graphics.rectangle('fill', menuX, menuY * scaleH, love.graphics.getWidth()-menuX*2, (state.MENU_HEIGHT-menuY*2) * scaleH, 9 * scale)
	love.graphics.setColor(palette[3])
	love.graphics.setColor(palette[3])
	love.graphics.setFont(self.font)
	love.graphics.scale(scale)
	
	if self.mode == "game" then
		local score = string.format("Счет: %d", self.score)
		local best = string.format(
			"%s рекорд: %d", 
			self.scene.level.name and "["..self.scene.level.name.."]" or "", 
			self.highscores[self.lvl] or 0
		)
			
		love.graphics.printf(score, indentX, indentY, love.graphics.getWidth() - indentX, "left")
		love.graphics.printf(best, 0, indentY, (love.graphics.getWidth()/scaleW) - indentX, "right")
	elseif self.mode == "fight" then
		love.graphics.printf(self.scene.score[1], indentX, indentY, love.graphics.getWidth() - indentX, "left")
		love.graphics.printf(self.scene.score[2], 0, indentY, (love.graphics.getWidth()/scaleW) - indentX, "right")
	end
	love.graphics.pop()
	
	love.graphics.push()
		local offset = 10 * scaleH		
		local indentY = ((state.MENU_HEIGHT) - state.CELL)/2
		love.graphics.translate(450*scaleW, indentY*scaleH)
		
		for l = 1, self.life do		
			local siz = self.lifes[l] * (state.CELL/20) * scale
			love.graphics.setColor(palette[4])
			love.graphics.rectangle('fill', (l-1) * (state.CELL + offset), 0, siz, state.CELL * scale)
		end
		for b = 1, self.max_life do
			local siz = state.CELL * scale
			love.graphics.setColor(palette[4][1], palette[4][2], palette[4][3], 0.5)
			love.graphics.setLineWidth(2 * scale)
			love.graphics.rectangle('line', (b-1) * (state.CELL + offset), 0, siz, state.CELL * scale)
		end
	love.graphics.pop()			
end

return game
