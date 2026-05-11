local Faled = Modules.Menu:new({
	offsetY = 200,
	y = 180,
	x = 250,
	item = 5,
	width = 500,
	height = 340,
	strings = {
		[1] = {
			nam = function(s)
				return "Твой счет: "..s.game.score
			end,
			skip = true
		},
		[2] = {
			nam = function(s)
				return s.msg
			end,
			skip = true
		},
		[3] = 'skip',
		[4] = 'skip',
		[5] = {
			nam = "повторить", 
			act = function(s) 
				s.game:restart() 
			end},
			
		[6] = {
			nam = "назад", 
			act = function(s) 
				funct.switchScreen('options') 
				s.item = 6	 
			end},
	},
	game_over = {
		[0] = "Ну ты и Тормозила!",
		[1] = "Уже лучше, но плохо...",
		[2] = "Хорошее начало! \nЁще сотня попыток \n у тебя все получится",
		[3] = "Почти профи! \nНо почти не считается :[",
		[4] = "Мастер приближается! \nГде то в другой вселенной(",
		[5] = "Ухх! Можешь когда захочешь! \nЗмейка - легенда!",
	},
	msg = ""
	
}, game)

return Faled
