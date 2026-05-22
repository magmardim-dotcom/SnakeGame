local funct = {}

function funct.loadScripts(folder)
	local scripts = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for _,item in ipairs(items) do
		local item = string.match(item, "%a+")
		local s = folder.."/"..item
		
		scripts[item] = require (s)
	end
	
	return scripts
end

function funct.loadAudio(folder)
	local audio = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do
		local item = love.audio.newSource(folder.."/"..v, "static")	
		
		audio[v] = item
		print("load audio: "..v)
	end
		
	return audio
end

function funct.loadLevels(folder)
	local levels = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do	
		local i = string.find(v, "%.")		
		local item = string.sub(v, 1, i-1)	

		table.insert(levels, item)
	end
	
	return levels
end


function funct.scaler(base_w, base_h, new_w, new_h)
	return new_w/base_w, new_h/base_h
end

function funct.switchScreen(to)
	curScreen = to
	return true
end

function funct.fullScreen(bul)
	state.fullScreen = bul
	love.window.setFullscreen(bul)
	local newW, newH = love.graphics.getDimensions() 
	local scaleW, scaleH = funct.scaler(state.BASIC_W, state.BASIC_H, newW, newH)
	state.scaleW, state.scaleH = scaleW, scaleH
end

local function serialize(val)
    local t = type(val)
    if t == "boolean" then
        return "bool:" .. (val and "true" or "false")
    elseif t == "number" then
        return "num:" .. tostring(val)
    else
        return "str:" .. tostring(val)
    end
end

local function deserialize(s)
    local typ, v = s:match("^([%w]+):(.+)$")
    if typ == "bool" then
        return v == "true"
    elseif typ == "num" then
        return tonumber(v)
    else
        return v
    end
end

function funct.saveState(state)
	local lines = {}
	
	for k, v in pairs(state) do
		local t = string.format("[%s]='%s'", k, serialize(v))
		table.insert(lines, t)
    end
    
    love.filesystem.write("saveState.txt", table.concat(lines, "\n"))
    return true
end

function funct.loadState(state)
	local loaded = state

	if love.filesystem.getInfo("saveState.txt") then
		for line in love.filesystem.lines("saveState.txt") do
			local key, var = line:match("^%[(.-)%]%=%'(.-)%'")
			if key then
                loaded[key] = deserialize(var)
            end
		end
	end
	return loaded
end

return funct
