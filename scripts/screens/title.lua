local mode = {"c Другом", "c Компом", "между Компами"}

local newgame = {
	nam = "Играть", 
	act = function(s) 
		s.game:sceneLoad(s.game.lvl)
		s.game.mode = "game"
		funct.switchScreen('options') 
	end}
	
local options = {
	nam = "Настройки", 
	act = function() 
		funct.switchScreen('stateOptions') 
	end}

local exit = {nam = "Выход", act = function() love.event.quit() end}

local fight = {
	nam = function(s)
		return "Дуэль "..mode[s.m]
	end,
	left = function(s)
		if s.m - 1 >= 1 then s.m = s.m - 1 else s.m = #mode end
	end,
	right = function(s)
		if s.m + 1 <= #mode then s.m = s.m + 1 else s.m = 1 end
	end,
	act = function(s) 
		s.game.mode = "fight"
		s.game.scene.score = {0, 0}
		s.game:sceneLoad(s.game.lvl)
		s.game:playMusic()
		s.game.play = true
		s.game:restart(s.game.mode, s.m)
		funct.switchScreen('faled')
	end
}

local Title = Modules.Menu:new({
	m = 3,
	item = 2,
	offsetY = 300,
	width = state.BASIC_W,
	height = state.BASIC_H,
	strings = {
		[1] = newgame,
		[2] = fight,
		[3] = options,
		[4] = exit,
	},
	pic = function(s)
		
		--~ local green = PaletteList[state.palette][4]
		--~ local yellow = PaletteList[state.palette][3]
		--~ local sd = function(s, col, size, x, y)
			--~ local z = love.graphics.newText(Font, s)
			--~ love.graphics.push()
			--~ love.graphics.setColor(col)
			
			--~ love.graphics.draw(z, x*state.scaleW, y*state.scaleH, 0, 2 * state.scaleH)
			--~ love.graphics.pop()
		--~ end
		
		--~ love.graphics.push()		
		--~ love.graphics.translate(260 * state.scaleW, 100 * state.scaleH)
		--~ sd("а", green, 125, 232, 13)
		--~ sd("к", yellow, 100, 204, -4)
		--~ sd("й", green, 75, 168, 30)
		--~ sd("е", yellow, 75, 128, 25)
		--~ sd("м", green, 75, 68, 12)
		--~ sd("З", yellow, 150, 0, 0)
		--~ love.graphics.pop()
	end
})


return Title
