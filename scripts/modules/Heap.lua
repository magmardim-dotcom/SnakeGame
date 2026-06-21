local Heap = {}

function Heap:new()
	local h = {values = {}, index = {}, size = 0}
	
	return setmetatable(h, {__index = self})
end

function Heap:swap(i, j)
	self.index[self.values[i].v], self.index[self.values[j].v] = j, i
	self.values[i], self.values[j] = self.values[j], self.values[i]
end

function Heap:up(idx)
	local values = self.values
	while idx > 1 do
		local parent = math.floor(idx/2) 

		if values[idx].f > values[parent].f then break end
		self:swap(idx, parent)
		idx = parent
	end
end

function Heap:down(idx)
	local values = self.values
	
	while true do
		local left = idx*2
		local right = left + 1
		local i = idx
		
		if left <= self.size and values[i].f > values[left].f then
			i = left
		end
		
		if right <= self.size and values[i].f > values[right].f then
			i = right	
		end
		
		if i == idx then break end
		
		self:swap(idx, i)
		idx = i
	end
end

function Heap:push(val)
	local size = self.size + 1
	
	self.size = size
	self.values[size] = val
	self.index[val.v] = size
	
	self:up(self.size)
end

function Heap:pop()
	if self:empty() then return nil end
	
	local p = self:peek()
	
	self:swap(1, self.size)
	self:poplast()
	
	if self.size > 0 then self:down(1) end
	
	return p
end

function Heap:peek()
	if self:empty() then return nil end
	return self.values[1]
end

function Heap:remove(val)
	local p = self.index[val.v]
	if not p then return false end
	
	if p < self.size then self:swap(p, self.size) end
	
	self:poplast()
	
	if not self:empty() and p <= self.size then
        self:up(p)
        self:down(p)
    end
    
	return true
end

function Heap:poplast()
	if self:empty() then return false end
	
	local lv = self.values[self.size]
	self.index[lv.v] = nil
	self.values[self.size] = nil
	self.size = self.size - 1
	return lv
end

function Heap:empty()
	return self.size == 0
end

function Heap:decreaseKey(val)
	local p = self.index[val.v]
	if not p then return false end
	
	local oldf = self.values[p].f
	self.values[p] = val
	
	if oldf > val.f then
		self:up(p)
	elseif oldf < val.f then
		self:down(p)
	end
end

function Heap:is_in(v)
	local i = self.index[v]
	if i then
		return self.values[i]
	end
	return false
end

return Heap
