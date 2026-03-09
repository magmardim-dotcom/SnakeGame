Tremor = {}
	Tremor.__index = Tremor
	
function Tremor:new(intens)
	local tremor = {}
		tremor.act = false
		tremor.ox = 0
		tremor.oy = 0
		tremor.intens = intens or 1
		tremor.delay = nil
		
	return setmetatable(tremor, self)
end

function Tremor:set()
	love.graphics.push()
	love.graphics.translate(self.ox, self.oy)
end

function Tremor:unset()
	love.graphics.pop()
end

function Tremor:update(dt)
	local t = {1, 0, -1}
	
	if self.act then
		self.ox = t[math.random(1, 3)] * self.intens
		self.oy = t[math.random(1, 3)] * self.intens
		
		if self.delay and self.delay > 0 then
			self.delay = self.delay - 1
		elseif self.delay == 0 then
			self.delay = 0
			self:activate(false)
			self.ox = 0
			self.oy = 0
		end
	end
end

function Tremor:activate(bul, delay)
	self.act = bul or false
	self.delay = delay or nil
	
	if not act then 
		self.ox = 0 
		self.oy = 0 
	end
end

return Tremor
