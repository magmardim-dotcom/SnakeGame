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

function Path:search(gx, gy)
    local map   = self.map
    local maxY  = #map
    local maxX  = #map[1]

    -- ---------- очередь (FIFO) ----------
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

    -- ---------- старт ----------
    local startKey = string.format("%d,%d,%d,%d", self.x, self.y, self.dx, self.dy)
    local visited  = {[startKey] = true}
    local pred     = {}          -- key -> предыдущий state
    enqueue({x=self.x, y=self.y, dx=self.dx, dy=self.dy})

    local goalState = nil

    -- ---------- BFS ----------
    while true do
        local cur = dequeue()
        if not cur then break end

        if cur.x == gx and cur.y == gy then
            goalState = cur
            break
        end

        -- ---- генерируем только 3 допустимых направления ----
        local moves = {}

        -- 1. Прямо
        table.insert(moves, {dx=cur.dx, dy=cur.dy})

        -- 2. Налево
        local ldx, ldy
        if cur.dx == 1 and cur.dy == 0 then           -- идём вправо
            ldx, ldy = 0, -1
        elseif cur.dx == -1 and cur.dy == 0 then      -- идём влево
            ldx, ldy = 0, 1
        elseif cur.dx == 0 and cur.dy == 1 then       -- идём вниз
            ldx, ldy = 1, 0
        else                                          -- идём вверх
            ldx, ldy = -1, 0
        end
        table.insert(moves, {dx=ldx, dy=ldy})

        -- 3. Направо
        local rdx, rdy
        if cur.dx == 1 and cur.dy == 0 then           -- идём вправо
            rdx, rdy = 0, 1
        elseif cur.dx == -1 and cur.dy == 0 then      -- идём влево
            rdx, rdy = 0, -1
        elseif cur.dx == 0 and cur.dy == 1 then       -- идём вниз
            rdx, rdy = -1, 0
        else                                          -- идём вверх
            rdx, rdy = 1, 0
        end
        table.insert(moves, {dx=rdx, dy=rdy})

        -- ---- проверяем соседние клетки ----
        for _, m in ipairs(moves) do
            local nx = cur.x + m.dx
            local ny = cur.y + m.dy

            if nx >= 1 and nx <= maxX and ny >= 1 and ny <= maxY then
                if map[ny][nx] == 0 then          -- свободна
                    local key = string.format("%d,%d,%d,%d", nx, ny, m.dx, m.dy)
                    if not visited[key] then
                        visited[key] = true
                        pred[key] = cur
                        enqueue({x=nx, y=ny, dx=m.dx, dy=m.dy})
                    end
                end
            end
        end
    end

    -- ---------- восстановление пути ----------
    self.path = {}
    if goalState then
        local s = goalState
        while true do
            table.insert(self.path, 1, {x=s.x, y=s.y})
            local key = string.format("%d,%d,%d,%d", s.x, s.y, s.dx, s.dy)
            local p = pred[key]
            if not p then break end
            s = p
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
