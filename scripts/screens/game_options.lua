local GO = {
	offsetY = 150,
	strings = {
		[1] = {
			nam = "Начать", 
			act = function() 
				game:restart()	
				switch_screen('faled') 
			end},
		[2] = 'skip',
		[3] = {
			nam = "Настройки игры",
			skip = true
		},
		[4] = {
			nam = function() 
				return "Уровень: "..game.lvl 
			end, 
			right = function(s)						
				if game.lvl + 1 <= #levels then game.lvl = game.lvl + 1 else game.lvl = 1 end
			end,
			left = function(s)						
				if game.lvl - 1 >= 1 then game.lvl = game.lvl - 1 else game.lvl = #levels end
			end},
		[5] = {
			nam = function() return "Скорость: "..game.speed end, 
			right = function(s)						
				if game.speed + 1 <= 10 then game.speed = game.speed + 1 else game.speed = 1 end
			end,
			left = function(s)						
				if game.speed - 1 >= 1 then game.speed = game.speed - 1 else game.speed = 10 end
			end},
		[6] = {
			nam = function() 
				local onoff = function()
					if game.hunger then
						return "Да"
					else
						return "Нет"
					end
				end
				
				return "Голод: "..onoff()
			end,
			act = function(s)
				game.hunger = not game.hunger
			end,
			right = function(s)						
				game.hunger = not game.hunger
			end,
			left = function(s)						
				game.hunger = not game.hunger
			end
		},
		[7] = {nam = "Назад", 
			act = function() 
				switch_screen('title') 
			end},
	},
}

return Menu:new(GO)
