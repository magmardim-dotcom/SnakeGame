local options = {}
	options.item = 2
	options.width = 400
	options.height = 200
	options.game_over = {
		[0] = "Ну ты и Тормозила!",
		[1] = "Уже лучше, но плохо...",
		[2] = "Хорошее начало! Ёще сотня попыток и у тебя все получится",
		[3] = "Почти профи! Но почти не считается :[",
		[4] = "Мастер приближается! Где то в другой вселенной(",
		[5] = "Ухх! Можешь когда захочешь! Змейка - легенда!",
	}
	options.msg = ""

function options:draw(x, y)
	local a = 28
	
	love.graphics.push()
		love.graphics.translate(x,y)
		love.graphics.setColor(0,0,0, 1)
		love.graphics.rectangle('fill', 0,0, self.width, self.height)
		love.graphics.setColor(palette[game.palette][2])
		
		local texts = {
			[1] = {pos = 1, it = "Уровень: '"..tostring(game.lvl).."'", game.lvl},
			[2] = {pos = 2, it = "Скорость: '"..tostring(game.speed).."'", game.speed},
			[3] = {pos = 3, it = "Палитра: '"..tostring(game.palette).."'", game.palette}
		}
		
		local msg = function(tab, t)
			local text = tab[t].it
			local p = tab[t].p
			
			if self.item == t then
				return "* "..text.." *"
			else
				return text
			end
		end
		
		love.graphics.translate(0, a/2)
		love.graphics.printf(msg(texts, 1), font, 0, 0, self.width, "center")
		love.graphics.printf(msg(texts, 2), font, 0, a, self.width, "center")
		love.graphics.printf(msg(texts, 3), font, 0, a*2, self.width, "center")
		love.graphics.translate(0, 10)
		love.graphics.printf("Твой счёт: "..game.score, font, 0, a*5, self.width, "center")
		love.graphics.setColor(palette[game.palette][4])
		love.graphics.printf(self.msg, font, 0, a*3, self.width, "center")
	love.graphics.pop()
end

function options:keypressed(key, down, up, right, left, restart)
	local turn = function(var, key, key1, key2, max)
		local v = var
		
		if key == key1 then
			if v + 1 <= max then
				return var + 1
			else
				return 1
			end
		elseif key == key2 then
			if v - 1 > 0 then
				return var - 1
			else
				return max
			end
		end
		return var
	end
	
	self.item = turn(self.item, key, down, up, 3)
		
	if self.item == 1 then
		game.lvl = turn(game.lvl, key, right, left, 5)
	elseif self.item == 2 then
		game.speed = turn(game.speed, key, right, left, 12)
	elseif self.item == 3 then
		game.palette = turn(game.palette, key, right, left, 5)
	end
	
	if key == restart then
		game:restart()
		print ("::new game::")
	end
end


return options
