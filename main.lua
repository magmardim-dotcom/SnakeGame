local dbg = require "scripts/dbg"
	visDbg = false

funct = require "scripts/functions" 
state = require "scripts/state"
local game = require "scripts/game"

function love.load()
	math.randomseed(os.time())
	Font = love.graphics.newFont(state.BASIC_FONT, state.FONT_SIZE, "normal", 4)
	Audio = funct.loadAudio("resurses/fx")
	Music = funct.loadAudio("resurses/music")
	PaletteList = require "scripts/palette-list"
	Modules = funct.loadScripts("scripts/modules") 
	state = funct.loadState(state) 	
	Modules.Menu.game = game
	Screens = funct.loadScripts("scripts/screens")
	game:load()
		curScreen = 'title'
	if love.system.getOS() == "Android" then
		funct.fullScreen(true)
	end
end

function love.draw()
	local palette = PaletteList[state.palette]
	local h = love.graphics.getHeight() 
	local scale = math.min(state.scaleW, state.scaleH)
	local offsetY = (h - (state.BASIC_H*scale))/2 
	
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setBackgroundColor(palette[3])
	
	love.graphics.push()
	love.graphics.translate(0, offsetY)
	if curScreen == "faled"  then
		game:draw(palette)
	end
	love.graphics.pop()
	
	if not game.play then
		Screens[curScreen]:draw(palette[1], palette[2], palette[3], palette[4], Font)
	end
		
	if visDbg then dbg:draw(30, 50) end
end

function love.update(dt)
	state:limitFPS()
	game:update(dt) 
end

function love.keypressed(key)
	if game.play then
		game:keypressed(key, "s", "w", "a", "d")
	else
		Screens[curScreen]:keypressed(key, "s", "w", "a", "d", "x")
	end
	
	if key == 'f1' then
		love.event.quit('restart')
	end
	
	if key == 'f2' then
		funct.fullScreen(not state.fullScreen)
	end
	
	if key == 'escape' then
		love.event.quit()
	end
	
	if key == 'f12' then
		visDbg = not visDbg
	end
end

function love.quit()
	game:quit()
	funct.saveState(
		{
			['palette'] = state.palette,
			['fullScreen'] = state.fullScreen,
			['musicPlay'] = state.musicPlay,
			['musicVol'] = state.musicVol,
		}
	)	
end

function love.resize(w, h)
	local width, height = love.window.getDesktopDimensions() 
	
	if w > width and h > height then
		state.BASIC_W, state.BASIC_H = w, h
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	Screens[curScreen]:touchpressed()
end
