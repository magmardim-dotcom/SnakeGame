local levelS = {
	nam = function(s) 
		return "Выбор уровня"
	end, 
	skip = true
}

local levleN = {
	nam = function(s) 
		return s.game.scene.level.name or ""
	end,
	right = function(s)					
		if s.game.lvl + 1 <= #s.game.levels then s.game.lvl = s.game.lvl + 1 else s.game.lvl = 1 end
		s.game:sceneLoad(s.game.lvl)		
	end,
	left = function(s)						
		if s.game.lvl - 1 >= 1 then s.game.lvl = s.game.lvl - 1 else s.game.lvl = #s.game.levels end
		s.game:sceneLoad(s.game.lvl)
	end
}

local levelB = {
	nam = function(s) 
		return string.format ("Рекорд: %s", s.game.highscores[s.game.lvl] or "")
	end, 
	skip = true 
}

local back = {
	nam = function(s) 
		return "Назад"
	end,
	act = function(s) 
		funct.switchScreen('options') 
		s.item = 2	 
	end
}

return Modules.Menu:new(
	{
		offsetY = 40,
		modI = 1,
		item = 2,
		width = state.BASIC_W,
		height = state.BASIC_H,
		strings = {
			levelS, levleN, "skip", "skip", "skip", "skip", levelB, back
		},
		pic = function(s)
			local scale = .4 * math.min(state.scaleW, state.scaleH)
			local canvas = s.game.scene.canvas			
			local ox = ((love.graphics.getWidth() - canvas:getWidth() * scale)/2)
			local oy = s.offsetY + (90 * state.scaleH)
			
			love.graphics.push()
			love.graphics.translate(0, s.offsetY)
			love.graphics.setLineWidth(4 * math.min(state.scaleW, state.scaleH))
			love.graphics.setLineStyle("rough")
			love.graphics.rectangle("line", ox, oy, canvas:getWidth() * scale, canvas:getHeight() * scale)
			love.graphics.draw(canvas, ox, oy, 0,  scale, scale)
			love.graphics.pop()
		end
	}
)
