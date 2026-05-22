local GO = {
	offsetY = 100,
	width = state.BASIC_W,
	height = state.BASIC_H,
	speed = {
		i = 2,
		[1] = {s = 3, nam = "медлено"},
		[2] = {s = 5, nam = "норма"},
		[3] = {s = 7, nam = "быстро"},
	},
	strings = {
		[1] = {
			nam = "Начать", 
			act = function(s) 
				s.game:sceneLoad(s.game.lvl)
				s.game.play = true
				funct.switchScreen('faled') 
			end},
		[2] = 'skip',
		[3] = {
			nam = "Настройки игры",
			skip = true
		},
		[4] = {
			nam = function(s) 
				return "Уровень: "..(s.game.lvl) 
			end, 
			right = function(s)					
				if s.game.lvl + 1 <= #s.game.levels then s.game.lvl = s.game.lvl + 1 else s.game.lvl = 1 end
				
			end,
			left = function(s)						
				if s.game.lvl - 1 >= 1 then s.game.lvl = s.game.lvl - 1 else s.game.lvl = #s.game.levels end
			end},
		[5] = {
			nam = function(s) return "Скорость: "..s.speed[s.speed.i].nam end, 
			right = function(s)						
				if s.speed.i + 1 <= 3 then 
					s.speed.i = s.speed.i + 1 
					s.game.speed = s.speed[s.speed.i].s 
				end
			end,
			left = function(s)						
				if s.speed.i - 1 >= 1 then 
					s.speed.i = s.speed.i - 1 
					s.game.speed = s.speed[s.speed.i].s
				end
			end},
		[6] = {
			nam = function(s) 
				local onoff = function()
					if s.game.hunger then
						return "Да"
					else
						return "Нет"
					end
				end
				
				return "Голод: "..onoff()
			end,
			act = function(s)
				s.game.hunger = not s.game.hunger
			end,
			right = function(s)						
				s.game.hunger = not s.game.hunger
			end,
			left = function(s)						
				s.game.hunger = not s.game.hunger
			end
		},
		[7] = {nam = "Назад", 
			act = function() 
				funct.switchScreen('title') 
			end},
	},
}

return Modules.Menu:new(GO)
