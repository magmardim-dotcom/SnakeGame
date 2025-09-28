local t = {
    {1,1,1,1,1},
    {1,0,0,0,1},
    {1,1,1,0,1},
    {1,0,0,0,1},
    {1,1,1,1,1},
  }
  
  function ser_nod(graf, nam)
      local nod = graf[nam]
      if not nod then 
        nod = {nam = nam, adj = {}} 
        graf[nam] = nod
      end
      
      return nod
  end
  
  function fromTabletoGraf(t)
    local graf = {}
    
    for y = 1, #t do
      for x = 1, #t[y] do
        local cell = t[y][x]
        
        if cell == 0 then
          local nam = y.."-"..x
          local node = ser_nod(graf, nam)
          if t[y][x-1] == 0 then local to = ser_nod(graf, y.."-"..(x-1)) node.adj[to] = true end
          if t[y][x+1] == 0 then local to = ser_nod(graf, y.."-"..(x+1)) node.adj[to] = true end
          if t[y-1][x] == 0 then local to = ser_nod(graf, (y-1).."-"..x) node.adj[to] = true end
          if t[y+1][x] == 0 then local to = ser_nod(graf, (y+1).."-"..x) node.adj[to] = true end
        end
      end
    end
    
    return graf
  end
  
graf = fromTabletoGraf(t)
  
function search(from, to, path, visited)
  path = path or {}
  visited = visited or {}
  
  if visited[from] then
    return nil
  end
  
  visited[from] = true
  path[#path + 1] = from
  
  if from == to then
    return path
  end
  
  for node in pairs(from.adj) do
    local p = search(node, to, path, visited)
    if p then return p end
  end
  
  path[#path] = nil
end

function printpath (path)
  if path == nil then print "Пути не существует" return false end
  for k,v in pairs(path) do
    print(v.nam)
  end
  
end

local from = ser_nod(graf, "2-2")
local to = ser_nod(graf, "4-2")
path = search(from, to)
printpath(path)
