local Vec = {}	
Vec.__index = Vec

function Vec:new(x, y)
	local v = {}
		v.x = x or 0
		v.y = y	or 0	
	
	return setmetatable(v, self)
end

function Vec:__tostring()
	return 'x:'..self.x..' y:'..self.y
end

function Vec:__add(vec2)
	local v = {}
	local x = self.x + vec2.x
	local y = self.y + vec2.y
	
	return Vec:new(x,y)
end

function Vec:__sub(vec2)
	local v = {}
	local x = self.x - vec2.x
	local y = self.y - vec2.y
	
	return Vec:new(x, y)
end

function Vec:__mul(vec2)
	local x,y
	
	if getmetatable(vec2) == Vec or type(vec2) == "table" then
		x = self.x * vec2.x
		y = self.y * vec2.y		
	elseif type(vec2) == "number" then
		x = self.x * vec2
		y = self.y * vec2
	end
		
	return Vec:new(x, y)
end

local function isVector(...)	
	for _,v in ipairs({...}) do
		assert(type(v) == "table" and type(v.x) == "number" and type(v.y) == "number", "this is not a Vector")
	end
end

function Vec:getLenght(vec)
	return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

function Vec:normalizeVector()	
	local d = self:getLenght()
	
	local normal = {} 			 
		normal.x = self.x/d
		normal.y = self.y/d
			
	return Vec:new(normal.x, normal.y)
end

function Vec:scalarProduct(vec2)
	isVector(vec2)
	
	return self.x * vec2.x + self.y * vec2.y
end

function Vec:skewProduct(vec2)
	isVector(vec2)
	return self.x * vec2.y - vec2.x * self.y
end

function Vec:angBtVectors(vec2)
	isVector(vec2)
	
	local scal = self:scalarProduct(vec2)
	local prod = self:getLenght() * vec2:getLenght()
	
	return math.acos(scal/prod)
end

return Vec
