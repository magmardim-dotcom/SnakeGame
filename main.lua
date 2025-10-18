Tremor 	= require "tremor"

dbg 	= require "dbg"
snake 	= require "snake"
apple 	= require "apple"
levels	= require "lvls"
game	= require "game"
scene	= require "scene"
options	= require "options"
palette = require "palette-list"

local function load_music(folder)
	local music = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do
		local item = love.audio.newSource(folder.."/"..v, "static")	

		table.insert(music, item)
	end
	
	return music
end

local function load_levels(folder)
	local levels = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do	
		local i = string.find(v, "%.")		
		local item = require (folder.."/"..(string.sub(v, 1, i-1)))	

		table.insert(levels, item)
	end
	
	return levels
end

function love.load()
	
	player = load_music("music")
	game.player = player[game.music]
	levels = load_levels("levels")
	screem = love.audio.newSource("fx/aaa.ogg", "stream")
	
	game_over = love.audio.newSource("fx/end.ogg", "static")
	eat = love.audio.newSource("fx/hrum.ogg", "static")
	
	love.audio.setEffect("myEffect2", {type="reverb", diffusion = 1, gain = 0.8})
	love.audio.setEffect("myEffect", {
		type = "distortion",
		gain = .6,
		edge = .3,
	})
	screem:setEffect("myEffect")
	screem:setEffect("myEffect2")
	
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('linear')
	font = love.graphics.newFont("gcmc.otf", 24)
	font_fullscreen = love.graphics.newFont("gcmc.otf", 24*scaler())
	love.graphics.setFont(font)
		
	game:load()
	
	if love.filesystem.getInfo("highscores.txt") then
		local l = 1
		
		for lines in love.filesystem.lines("highscores.txt") do
			game.highscores[l] = tonumber(lines)
			l = l + 1
		end
	else
		love.filesystem.newFile("highscores.txt")
	end
	
	if love.system.getOS() == "Linux" then
		SetFullscreenMode(true)
		game.speed = 6
	end
end

function love.draw()
	love.graphics.setBackgroundColor(1,1,1)
	game:draw_top_menu()
	
	love.graphics.push()
		love.graphics.scale(scaleW, scaleH)
		scene:draw()
		love.graphics.setColor(1,1,1)	
		
	love.graphics.pop()
	if not game.play then
		local x = love.graphics.getWidth()/2 - options.width/2*scaleW
		local y = love.graphics.getHeight()/2 - options.height/2*scaleH
			
		options:draw(x,y)
	end
	if dbg then dbg:draw() end
end

function love.update(dt)
	scene:update(dt)
	
	if not game.play then return end
	game:update(dt)
end

function love.keypressed(key)	
	if game.play then
		snake:control(key)
	else
		options:keypressed(key, "s", "w", "d", "a", "x")
	end
		
	if key == 'f1' then
		love.event.quit('restart')
	end
	
	if key == 'f2' then
		local fullscreen, fstype = love.window.getFullscreen( )
		
		SetFullscreenMode(not fullscreen)
	end
	
	if key == 'escape' then
		love.event.quit()
	end
	
	if key == 'f12' then
		if dbg.show then
			dbg.show = false
		else
			dbg.show = true
		end
	end
end

function scaler()
	local width, height = love.window.getDesktopDimensions()
	
	return width/def_width, height/def_height
end

function SetFullscreenMode(boolean)
	if boolean then
		love.window.setFullscreen(true)
		scaleW, scaleH = scaler()
		love.graphics.setFont(font_fullscreen)
	else
		love.window.setFullscreen(false)
		scaleW, scaleH = 1, 1
		love.graphics.setFont(font)
	end
end

function love.quit()
	local best = ""
	
	for l = 1, #levels do
		best = best..tostring(game.highscores[l]).."\n"
	end
	
	love.filesystem.write( "highscores.txt", best)
end
