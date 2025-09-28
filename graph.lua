local Queue = require("Queue")

-- Функция BFS, использующая нашу очередь
local function bfs(grid, startX, startY, targetX, targetY)
    local visited = {}
    local parent  = {}

    local q = Queue.new()
    q:enqueue({x = startX, y = startY})

    visited[startY] = true
    visited[startY] = visited[startY] or {}
    visited[startY][startX] = true

    local dirs = {
        {0, 1}, {1, 0}, {0, -1}, {-1, 0}
    }

    while not q:isEmpty() do
        local node = q:dequeue()
        local x, y = node.x, node.y

        -- Яблоко найдено – восстанавливаем путь
        if x == targetX and y == targetY then
            local path = {}
            while not (x == startX and y == startY) do
                table.insert(path, 1, {x = x, y = y})
                local p = parent[y][x]
                x, y = p.x, p.y
            end
            return path   -- путь от головы к яблоку
        end

        -- Перебираем соседей
        for _, d in ipairs(dirs) do
            local nx, ny = x + d[1], y + d[2]
            if nx > 0 and nx <= #grid[1] and
               ny > 0 and ny <= #grid and
               grid[ny][nx] == 0 and
               not (visited[ny] and visited[ny][nx]) then

                visited[ny] = visited[ny] or {}
                visited[ny][nx] = true
                parent[ny] = parent[ny] or {}
                parent[ny][nx] = {x = x, y = y}

                q:enqueue({x = nx, y = ny})
            end
        end
    end

    return nil   -- путь не найден
end
