local Title = Menu:new({
	offsetY = 300,
	strings = {
		[1] = {nam = "Играть", 
				act = function() 
					--~ game:restart()
					switch_screen('game_options') 
				end},
		[2] = {nam = "Настройки", 
			act = function() 
				--~ switch_screen('options') 
			end},
		[3] = {nam = "Выход", act = function() love.event.quit() end},
	},
	pic = function(s)
		
		local green = GetPalette()[4]
		local yellow = GetPalette()[3]
		local sd = function(s, col, size, x, y)
			love.graphics.setColor(col)
			font = love.graphics.newFont("gcmc.otf", size*scaleW)
			local z = love.graphics.newText(font, s)
			love.graphics.draw(z, x*scaleW, y*scaleH)
		end
		
		love.graphics.push()		
		love.graphics.translate(260*scaleW, 100*scaleH)
		sd("а", green, 125, 232, 13)
		sd("к", yellow, 100, 204, -4)
		sd("й", green, 75, 168, 30)
		sd("е", yellow, 75, 128, 25)
		sd("м", green, 75, 68, 12)
		sd("З", yellow, 150, 0, 0)
		love.graphics.pop()
	end
})


return Title
