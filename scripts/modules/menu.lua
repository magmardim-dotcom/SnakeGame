local Menu = {}
	Menu.__index = Menu
	
function Menu:new(menu)
	local menu = menu
		menu.item = menu.item or 1
		menu.offsetX = menu.offsetX or 0
		menu.offsetY = menu.offsetY or 0
		menu.x = menu.x or 0
		menu.y = menu.y or 0
		menu.width = menu.width or love.graphics.getWidth()
		menu.height = menu.height or love.graphics.getHeight()
		menu.game = Menu.game
		menu.frame = menu.frame or false
		menu.strings = menu.strings or {}
		
	return setmetatable(menu, self)
end

function Menu:draw(color1, color2, color3, color4, font)
	local width = self.width
	local height = self.height
	local font = self.font or font
	
	love.graphics.push()
	love.graphics.setColor(color1)
	love.graphics.rectangle('fill', self.x * state.scaleW, self.y * state.scaleH, width * state.scaleW, height * state.scaleH)
	if self.frame then
		love.graphics.setColor(color3)
		love.graphics.setLineWidth(10)
		love.graphics.rectangle('line', self.x * state.scaleW, self.y * state.scaleH, width * state.scaleW, height * state.scaleH)
	end
	love.graphics.pop()
	
	love.graphics.push()
	love.graphics.setFont(font)
	love.graphics.translate(self.offsetX * state.scaleW, self.offsetY * state.scaleH)
	
	love.graphics.setColor(color3)
	love.graphics.rectangle('fill', self.x * state.scaleW, font:getHeight() * (self.item - 1) * state.scaleH, self.width * state.scaleW, font:getHeight() * state.scaleH)
	
	love.graphics.setColor(color2)	
	if self.pic then self.pic(self) end
	
	love.graphics.scale(state.scaleW, state.scaleH)		
	
	for str = 1, #self.strings do
		local s = self.strings[str]
				
		Iselect = function(string)
			local nam = string
			
			if self.item == str then
				love.graphics.setColor(color2)
				nam = "< "..string.." >"
			else
				if s.color then
					love.graphics.setColor(s.color)
				else
					love.graphics.setColor(color4)
				end
			end
			return nam
		end
		
		local fontH = font:getHeight()
		
		if type(s.nam) == 'string' then
			love.graphics.printf(Iselect(s.nam), 0, (fontH) * (str - 1), (love.graphics.getWidth()/state.scaleW), 'center')
		elseif type(s.nam) == 'function' then
			love.graphics.printf(Iselect(s.nam(self)), 0, (fontH) * (str - 1), (love.graphics.getWidth()/state.scaleW), 'center')
		end
		
	end
	
	love.graphics.pop()
end

function Menu:update(dt)
	
end

function Menu:keypressed(key, down, up, left, right, restart)
	function skip(item, it, n)
		local it = it + n
		
		if it == 0 then
			return #self.strings
		end

		if item[it] == 'skip' or item[it].skip then
			return skip(item, it, n)			
		else
			return it
		end
	end
	
	if key == down and self.item + 1 <= #self.strings then
		self.item = skip(self.strings, self.item, 1)
	elseif key == up and self.item - 1 >= 1 then
		self.item = skip(self.strings, self.item, -1) 
	end
	
	local s = self.strings[self.item]
	
	if s.act and key == restart then
		s.act(self)
	end
	
	if s.right and key == right then
		s.right(self)
	end
	
	if s.left and key == left then
		s.left(self)
	end
end

function Menu:touchpressed()
	local s = self.strings[self.item]
	
	if s.act then
		s.act(self)
	end
end

return Menu
