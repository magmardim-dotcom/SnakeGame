local Heap = require "scripts/modules/Heap"

local encode = function(x, y, width)
	return (y - 1) * width + x
end

local decode = function(index, width)
	local x = (index - 1) % width + 1
    local y = math.floor((index - 1) / width) + 1
    return x, y
end

local dir = {
	{1,0}, {-1,0}, {0,1}, {0,-1}
}

local h = function(start, goal, W)
	local sx, sy = decode(start, W)
	local gx, gy = decode(goal, W)
	
	return math.abs(sx-gx) + math.abs(sy-gy)
end

local getNeighbors = function(i, map)
	local neighbors = {}
	local x,y = decode(i, map.width)
	for _, d in ipairs(dir) do
		local dx = x + d[1]
		local dy = y + d[2]
		if map[encode(dx, dy, map.width)] == 0 then
			neighbors[#neighbors+1] = encode(dx, dy, map.width)			
		end
	end
	return neighbors
end

local astar = function(start, goal, map)
	local width = map.width	
	local openset = Heap:new()
	local closedset = {}
	local camefrom = {}
	
	local current = {
		v = start,
		g = 0,
		f = 0 + h(start, goal, width)
	}
	
	openset:push(current)
	
	while not openset:empty() do
		current = openset:pop()
		
		if current.v == goal then
			local path = {}
			local node = current.v
			
			while node do
				table.insert(path, node)
				node = camefrom[node]
			end
			
			local result = {}
			
			for i = #path, 1, -1 do
				result[#result+1] = path[i]
			end
			
			return result
		end
		
		closedset[current.v] = true
		
		local neighbors = getNeighbors(current.v, map)
		
		for _, n in ipairs(neighbors) do
			if not closedset[n] then
				local tentative_g = current.g + 1
				local is_in = openset:is_in(n)
				
				if not is_in or tentative_g < is_in.g then
					camefrom[n] = current.v
					
					local neighbor = {
							v = n,
							g = tentative_g,
							f = tentative_g + h(n, goal, width)
						}
						
					if not is_in then
						openset:push(neighbor)
					else
						openset:decreaseKey(neighbor)
					end
					
					
				end
			end
		end
	end
	
	return nil
end

local Path = {}
Path.__index = Path

function Path:new(x, y, map)
    local path = {}    
		path.start = encode(x, y, #map[1])
		path.goal = nil
		path.map = {
			width = #map[1],
			height = #map
		}
		path.path = {}
		path.moves = {}
    
    for y = 1, path.map.height do
		for x = 1, path.map.width do
			path.map[encode(x, y, path.map.width)] = map[y][x]
		end
    end

    return setmetatable(path, self)
end

function Path:search(gx, gy)
	self.goal = encode(gx, gy, self.map.width) 
	self.path = astar(self.start, self.goal, self.map)
	if not self.path or #self.path < 2 then return end
	local x1, y1 = decode(self.path[1], self.map.width)
	local x2, y2 = decode(self.path[2], self.map.width)
	local dx, dy = x2-x1, y2-y1
	
	if dx == 1 and dy == 0 then
		self.moves[#self.moves + 1] = "right"
	elseif dx == -1 and dy == 0 then
		self.moves[#self.moves + 1] = "left"
	elseif dx == 0 and dy == 1 then
		self.moves[#self.moves + 1] = "down"
	elseif dx == 0 and dy == -1 then
		self.moves[#self.moves + 1] = "up"
	end
end

function Path:draw(color, cell)
	if not self.path then return end
	for _,v in pairs(self.path) do
		local x,y = decode(v, self.map.width)
		love.graphics.push()		
			love.graphics.setColor(color)			
			love.graphics.rectangle('fill', (x-1)*cell, (y-1)*cell, cell, cell)
		love.graphics.pop()
	end
end

return Path
