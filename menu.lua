Menu = {}
	Menu.__index = Menu
	
function Menu:new(menu)
	local menu = menu
		menu.item = 1
		menu.offsetX = menu.offsetX or 0
		menu.offsetY = menu.offsetY or 0
		menu.indent = menu.indent or 28
		menu.font = "gcmc.otf"
		menu.font_size = 24
		menu.bg_color = menu.bg_color or {1,1,1,1}
		menu.txt_color = menu.txt_color or {0,0,0}
		menu.select_color = menu.select_color or {1,0,0}
		
	return setmetatable(menu, self)
end

function Menu:draw()
	love.graphics.setColor(self.bg_color)
	love.graphics.rectangle('fill', 0,0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.push()	
	if self.pic then self.pic(self) end
	local font = love.graphics.newFont(self.font, self.font_size*scaleW)
	love.graphics.setFont(font)
	love.graphics.translate(self.offsetX*scaleW, self.offsetY*scaleH)
	
	for str = 1, #self.strings do
		local s = self.strings[str]
				
		Iselect = function(string)
			local nam = string
			
			if self.item == str then
				love.graphics.setColor(self.select_color)
				nam = "< "..string.." >"
			else
				if s.color then
					love.graphics.setColor(s.color)
				else
					love.graphics.setColor(self.txt_color)
				end
			end
			return nam
		end
				
		if type(s.nam) == 'string' then
			love.graphics.printf(Iselect(s.nam), 0, (self.indent * scaleW) * (str - 1), love.graphics.getWidth(), 'center')
		elseif type(s.nam) == 'function' then
			love.graphics.printf(Iselect(s.nam()), 0, (self.indent * scaleW) * (str - 1), love.graphics.getWidth(), 'center')
		end
		
	end
	love.graphics.pop()
end

function Menu:update(dt)
	
end

function Menu:keypressed(key, down, up, right, left, restart)
	function skip(item, it, n)
		local it = it + n
		
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
