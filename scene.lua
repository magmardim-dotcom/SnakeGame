local scene = {}
	scene.width = 630
	scene.height = 324
	scene.tremor = Tremor:new(3)
	scene.tr_x = 0 
	scene.tr_y = 0 

function scene:load(lvl)
	self.width = #lvl[1]*cell
	self.height = #lvl*cell
end

local function getViewOffset(oy)
    local WIDTH = love.graphics.getWidth()
    local HEIGHT = love.graphics.getHeight()
    
    local headX = snake.points[1].x * cell
    local headY = snake.points[1].y * cell

    local halfW = WIDTH  / 2
    local halfH = HEIGHT / 2
	
	local map = levels[game.lvl] 
    local mapW = #map[1] * cell
    local mapH = #map * cell

    local offsetX = headX - halfW
    local offsetY = headY - halfH

    offsetX = math.max(0, math.min(offsetX, mapW - WIDTH))
    offsetY = math.max(0, math.min(offsetY, mapH - HEIGHT + oy))

    return offsetX, offsetY
end

function scene:draw()
	local level = levels[game.lvl] 
	local pal = palette[game.palette]
	
	local menuHeight = 26 * scaleW
	offsetX, offsetY = getViewOffset(menuHeight)
	
	love.graphics.push()		
		local width = #level[1]
		local height = #level
		
		self.tremor:set()
		love.graphics.translate(-offsetX, -offsetY + menuHeight)			
		love.graphics.setColor(pal[1])
		love.graphics.rectangle('fill', 0,0, width*cell, height*cell)
				
		love.graphics.setColor(pal[2])
		
		for y = 1, height do
			for x = 1, width do
				local b = level[y][x]
				if b == 1 then
					love.graphics.push()
					love.graphics.translate((x-1)*cell, (y-1)*cell)
					love.graphics.rectangle('fill', 0, 0, cell, cell)
					love.graphics.pop()
				end
			end
		end
		
		snake:draw(pal[4])		
		apple:draw(pal[3])
		
		self.tremor:unset()
	love.graphics.pop()
end

function scene:update(dt)
	self.tremor:update(dt)
end

return scene
