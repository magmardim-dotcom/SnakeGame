local Faled = Modules.Menu:new({
	offsetY = 100,
	y = 80,
	x = 260,
	item = 5,
	width = 600,
	height = 390,
	strings = {
		[1] = {
			nam = function(s)
				return s.msg.."\nТвой счет: "..s.game.score
			end,
			skip = true},
		[2] = 'skip',
		[3] = 'skip',
		[4] = "skip",
		[5] = {
			nam = "повторить", 
			act = function(s) 
				s.game:restart() 
				s.item = 5
			end},
		[6] = {
			nam = "назад", 
			act = function(s) 
				funct.switchScreen('options') 
				s.game.music:setVolume(state.musicVol)
				s.game.music:stop()
				s.game.music:setEffect("reverb", false)
				s.item = 5	 
			end},
	},
	game_over = {
		[0] = "Тормоз — это диагноз! \nРеакция как у улитки...",
		[1] = "Ты даже не стараешься!",
		[2] = "Вижу старанее! \nА нет, показалось...",
		[3] = "Хорошее начало! \nЁще сотня попыток \nи у тебя может получиться",
		[4] = "Ты на верном пути! \nЖаль только, что путь \nведёт в тупик.",
		[5] = "Почти получилось! \nНо почти не считается(",
		[6] = "Техника на высоте! \nЖаль, что собственный \nхвост тебе мешает.",
		[7] = "Без комментариев... \nЭто было слишком круто для моих подколов.",
		[8] = "У змейки нет цели. \nЕсть только путь!",
		[9] = "Ты — само воплощение бесконечного пути. \nНастоящая легенда!!!",
	},
	msg = ""
	
}, game)

return Faled
