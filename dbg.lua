return {
  show = false,
  getFPS = function()
    return tostring(love.timer.getFPS())
  end,
  getMem = function()
    return string.format('%.0f', tostring(collectgarbage('count')))
  end,
  draw = function(s)
    if s.show then
		local width, height = love.graphics.getWidth(), love.graphics.getHeight()
		love.graphics.setColor(255, 0, 255, 1)
		love.graphics.print('FPS: '..s.getFPS())
		--~ love.graphics.printf('Width '..width..' Height '..height..' scale '..scale, 0, 0, width, 'center')
		love.graphics.printf('Memory: '..s.getMem(),0,0,love.graphics.getWidth(), 'right')
	end
  end
}
