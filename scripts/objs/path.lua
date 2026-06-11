local Path = {}
Path.__index = Path

function Path:new(x, y, dx, dy, map)
    local path = {}
    setmetatable(path, self)

    path.x   = x
    path.y   = y
    path.dx  = dx
    path.dy  = dy
    path.path = {}
    path.map = map

    return path
end

local function wrap(val, max)
    return ((val - 1 + max) % max) + 1
end

function Path:search(gx, gy)
    local map   = self.map
    local maxY  = #map
    local maxX  = #map[1]

    local queue = {}
    local head  = 1
    local enqueue = function(s) queue[#queue+1] = s end
    local dequeue = function()
        if head <= #queue then
            local s = queue[head]
            head = head + 1
            return s
        end
    end

    local startKey = string.format("%d,%d,%d,%d", self.x, self.y, self.dx, self.dy)
    local visited  = {[startKey] = true}
    local pred     = {}          
    enqueue({x=self.x, y=self.y, dx=self.dx, dy=self.dy})

    local goalState = nil

    while true do
        local cur = dequeue()
        if not cur then break end

        if cur.x == gx and cur.y == gy then
            goalState = cur
            break
        end

        local moves = {
            {dx=cur.dx, dy=cur.dy},
            (cur.dx==1 and {dx=0, dy=-1}) or
            (cur.dx==-1 and {dx=0, dy=1}) or
            (cur.dy==1  and {dx=1, dy=0}) or
            (cur.dy==-1 and {dx=-1, dy=0}),
            (cur.dx==1 and {dx=0, dy=1}) or
            (cur.dx==-1 and {dx=0, dy=-1}) or
            (cur.dy==1  and {dx=-1, dy=0}) or
            (cur.dy==-1 and {dx=1, dy=0})
        }

        for _, m in ipairs(moves) do
            local nx = wrap(cur.x + m.dx, maxX)
            local ny = wrap(cur.y + m.dy, maxY)

            if map[ny][nx] == 0 then
                local key = string.format("%d,%d,%d,%d",
                                          nx, ny, m.dx, m.dy)
                if not visited[key] then
                    visited[key] = true
                    pred[key] = cur
                    enqueue({x=nx, y=ny, dx=m.dx, dy=m.dy})
                end
            end
        end
    end
        
    if goalState then
        self.path = {}
        local state = goalState
        while state do
            table.insert(self.path, 1, {x=state.x, y=state.y})
            local key = string.format("%d,%d,%d,%d",
                                      state.x, state.y, state.dx, state.dy)
            state = pred[key]
        end

        self.moves = {}
        for i = 2, #self.path do
            local prev = self.path[i-1]
            local cur  = self.path[i]
            local dx   = cur.x - prev.x
            local dy   = cur.y - prev.y

            if dx > 0 then self.moves[#self.moves + 1] = "right" end
            if dx < 0 then self.moves[#self.moves + 1] = "left"  end
            if dy > 0 then self.moves[#self.moves + 1] = "down" end
            if dy < 0 then self.moves[#self.moves + 1] = "up"  end
        end
    end
	
    return goalState ~= nil
end


function Path:draw()
	local CELL = state.CELL
	local b = self.path
	for p = 1, #b do
		love.graphics.setColor(0, 1, 0, 0.4)
		love.graphics.rectangle('fill', (b[p].x-1) * CELL, (b[p].y-1) * CELL, CELL, CELL)
	end
	
end

return Path
