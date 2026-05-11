local Path = {}
Path.__index = Path

function Path:new(x, y)
    local path = {}
    setmetatable(path, self)

    path.x   = x
    path.y   = y
    path.tx  = x
    path.ty  = y
    path.path = {}
    path.map  = {}

    return path
end

local neighborOffsets = {
    { 0, -1}, { 1,  0},
    { 0,  1}, {-1,  0}
}
--~ -- Возвращает вес клетки (или 0, если клетка вне карты)
--~ local function getWeight(map, x, y)
    --~ if not map[y] then return 0 end
    --~ local v = map[y][x]
    --~ return v or 0
--~ end

--~ -- Стоимость перехода из (x1, y1) в (x2, y2)
--~ local function moveCost(map, x1, y1, x2, y2)
    --~ local weight = getWeight(map, x2, y2)
    --~ if weight == 0 then
        --~ return math.huge 
    --~ end
    --~ local diagonal = (x1 ~= x2) and (y1 ~= y2)
    --~ local base = diagonal and 1.4 or 1.0
    --~ return base * weight
--~ end

-- нахождение длины вектора 
local function heuristic(x1, y1, x2, y2)
    return math.abs(x2 - x1) + math.abs(y2 - y1) 
end

local function insertOpen(open, node)
    table.insert(open, node)
    -- Пузырьковая сортировка
    local i = #open
    while i > 1 do
        local p = math.floor(i / 2)
        if open[p].f <= open[i].f then break end
        open[p], open[i] = open[i], open[p]
        i = p
    end
end

local function popOpen(open)
    if #open == 0 then return nil end
    local root = open[1]
    local last = table.remove(open)
    if #open > 0 then
        open[1] = last
        
        local i = 1
        while true do
            local l = 2 * i
            local r = l + 1
            local smallest = i
            if l <= #open and open[l].f < open[smallest].f then
                smallest = l
            end
            if r <= #open and open[r].f < open[smallest].f then
                smallest = r
            end
            if smallest == i then break end
            open[i], open[smallest] = open[smallest], open[i]
            i = smallest
        end
    end
    return root
end

function Path:searchPath(tx, ty, map)
    self.tx = tx
    self.ty = ty
    self.map = map
    self.path = {}

    local closed = {}

    local open = {}

    local startKey = self.x .. "," .. self.y
    local startNode = {
        x = self.x, y = self.y,
        g = 0,
        h = heuristic(self.x, self.y, tx, ty),
        f = 0 + heuristic(self.x, self.y, tx, ty),
        parent = nil,
    }
    insertOpen(open, startNode)

    local found = false
    local goalNode = nil

    while #open > 0 do
        local current = popOpen(open)
        local currentKey = current.x .. "," .. current.y
        closed[currentKey] = current

        -- Если дошли до цели
        if current.x == tx and current.y == ty then
            found = true
            goalNode = current
            break
        end

        for _, off in ipairs(neighborOffsets) do
            local nx = current.x + off[1]
            local ny = current.y + off[2]
            local neighKey = nx .. "," .. ny

            if map[ny][nx] == 1 then
                goto continue
            end

            if closed[neighKey] then
                goto continue
            end

            --~ local tentativeG = current.g + moveCost(map, current.x, current.y, nx, ny)
            local tentativeG = current.g

            local inOpen = false
            local existingNode = nil
            for _, node in ipairs(open) do
                if node.x == nx and node.y == ny then
                    inOpen = true
                    existingNode = node
                    break
                end
            end

            if not inOpen then
                local node = {
                    x = nx, y = ny,
                    g = tentativeG,
                    h = heuristic(nx, ny, tx, ty),
                    f = tentativeG + heuristic(nx, ny, tx, ty),
                    parent = current,
                }
                insertOpen(open, node)
            elseif tentativeG < existingNode.g then
                existingNode.g = tentativeG
                existingNode.f = tentativeG + existingNode.h
                existingNode.parent = current
                table.sort(open, function(a, b) return a.f < b.f end)
            end

            ::continue::
        end
    end

    if found then
        local node = goalNode
        local rev = {}
        while node do
            table.insert(rev, {x = node.x, y = node.y})
            node = node.parent
        end
        self.path = {}
        for i = #rev, 1, -1 do
            table.insert(self.path, rev[i])
        end
    else
        self.path = {}
    end

    return found
end

function Path:draw()
	local CELL = state.CELL
	for p = 1, #self.path do
		love.graphics.setColor(0, 1, 0, 0.4)
		love.graphics.rectangle('fill', (self.path[p].x-1) * CELL, (self.path[p].y-1) * CELL, CELL, CELL)
	end
end

return Path
