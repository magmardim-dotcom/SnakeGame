local Menu = {}
	Menu.__index = Menu
	
function Menu:new(menu)
	local menu = menu
		menu.item = menu.item or 1
		menu.offsetX = menu.offsetX or 0
		menu.offsetY = menu.offsetY or 0
		menu.indent = menu.indent or BASIC_INDENT
		menu.font =  menu.font or BASIC_FONT
		menu.font_size = 32
		menu.x = menu.x or 0
		menu.y = menu.y or 0
		menu.width = menu.width or love.graphics.getWidth()
		menu.height = menu.height or love.graphics.getHeight()
		
	return setmetatable(menu, self)
end

function Menu:draw(palette)
	local width = self.width * scaleW
	local height = self.height * scaleH
	
	love.graphics.push()
	love.graphics.setColor(palette[2])
	love.graphics.translate(self.x * scaleW, self.y * scaleH)
	love.graphics.rectangle('fill', 0,0, width, height)
	love.graphics.pop()
	
	love.graphics.push()	
	if self.pic then self.pic(self) end
	
	local font = love.graphics.newFont(self.font, self.font_size*scaleH)
	love.graphics.setFont(font)
	love.graphics.translate(self.offsetX*scaleW, self.offsetY*scaleH)
	
	for str = 1, #self.strings do
		local s = self.strings[str]
				
		Iselect = function(string)
			local nam = string
			
			if self.item == str then
				love.graphics.setColor(palette[3])
				nam = "< "..string.." >"
			else
				if s.color then
					love.graphics.setColor(s.color)
				else
					love.graphics.setColor(palette[4])
				end
			end
			return nam
		end
		
		local indentS = math.min(scaleH, scaleW)	
		if type(s.nam) == 'string' then
			love.graphics.printf(Iselect(s.nam), 0, (self.indent * indentS) * (str - 1), love.graphics.getWidth(), 'center')
		elseif type(s.nam) == 'function' then
			love.graphics.printf(Iselect(s.nam(self)), 0, (self.indent * indentS) * (str - 1), love.graphics.getWidth(), 'center')
		end
		
	end
	love.graphics.pop()
end

function Menu:update(dt)
	
end

function Menu:keypressed(key, down, up, right, left, restart)
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

return Menu
