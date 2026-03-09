local Faled = Menu:new({
	offsetY = love.graphics.getHeight()/2 - 140*scaleH,
	y = love.graphics.getHeight()/2 - 140*scaleH,
	x = love.graphics.getWidth()/2 - 200*scaleW,
	width = 400,
	height = 280,
	item = 5,
	strings = {
		[1] = {
			nam = function()
				return "Твой счет: "..game.score
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
		[5] = {
			nam = "повторить", 
			act = function() 
				game:restart()	 
			end},
		[4] = 'skip',	
		[6] = {
			nam = "назад", 
			act = function() 
				switch_screen('game_options') 	 
			end},
	},
	game_over = {
		[0] = "Ну ты и Тормозила!",
		[1] = "Уже лучше, но плохо...",
		[2] = "Хорошее начало! Ёще сотня попыток и у тебя все получится",
		[3] = "Почти профи! Но почти не считается :[",
		[4] = "Мастер приближается! Где то в другой вселенной(",
		[5] = "Ухх! Можешь когда захочешь! Змейка - легенда!",
	},
	msg = ""
	
})

return Faled
