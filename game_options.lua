local GO = Menu:new({
	offsetY = 150,
	indent = 28,
	txt_color = {1, .62, .31},
	select_color = {0, .8, 0},
	strings = {
		[1] = {
			nam = "Начать", 
			act = function() 
				game:restart()	 
			end},
		[2] = 'skip',
		[3] = {
			nam = "Настройки игры",
			color = {.2,.2, 1},
			skip = true
		},
		[4] = {
			nam = function() return "Уровень: "..game.lvl end, 
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
			nam = function() return "Длина: "..game.inital_length end,
			right = function(s)						
				if game.inital_length + 1 <= 10 then game.inital_length = game.inital_length + 1 else game.inital_length = 1 end
			end,
			left = function(s)						
				if game.inital_length - 1 >= 3 then game.inital_length = game.inital_length - 1 else game.inital_length = 10 end
			end},
		[7] = {
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
		[8] = {
			nam = function() return "Кол-во яблок: "..game.max_apples end, 
			right = function(s)						
				if game.max_apples + 1 <= 10 then game.max_apples = game.max_apples + 1 else game.max_apples = 1 end
			end,
			left = function(s)						
				if game.max_apples - 1 >= 1 then game.max_apples = game.max_apples - 1 else game.max_apples = 10 end
			end},
		--~ [4] = {nam = "Назад", 
			--~ act = function() 
				--~ switch_screen('title') 
			--~ end},
	},
})

return GO
