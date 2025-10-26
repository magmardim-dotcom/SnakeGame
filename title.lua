local Title = {}

function Title:draw()
	local green = {0, .8, 0}
	local yellow = {1, .62, .31}
	local sd = function(s, col, size, x, y)
		local scal = 1 
		local fullscreen = love.window.getFullscreen( )
		if fullscreen then
			scal = scaler()
		end
		love.graphics.setColor(col)
		font = love.graphics.newFont("gcmc.otf", size*scal)
		local z = love.graphics.newText(font, s)
		love.graphics.draw(z, x*scal, y*scal)
	end
	
	sd("а", green, 125, 400, 33)
	sd("к", yellow, 100, 372, 16)
	sd("й", green, 75, 330, 50)
	sd("е", yellow, 75, 290, 45)
	sd("м", green, 75, 230, 32)
	sd("З", yellow, 150, 162, 20)	
end


return Title
