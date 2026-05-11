local dbg = require "scripts/dbg"
	visDbg = true

funct = require "scripts/functions" 
state = require "scripts/state"
local game = require "scripts/game"

function love.load()
	math.randomseed(os.time())
	Modules = funct.loadScripts("scripts/modules") 
	game:load(funct.loadLevels("levels"))
	Modules.Menu.game = game
	Screens = funct.loadScripts("scripts/screens")
		curScreen = 'title'
	Font = love.graphics.newFont(state.BASIC_FONT, state.FONT_SIZE, "normal", 4)
	PaletteList = require "scripts/palette-list"
end

function love.draw()
	local palette = PaletteList[state.palette]
	
	if curScreen == "faled"  then
		game:draw(palette)
	end
	
	if not game.play then
		Screens[curScreen]:draw(palette[1], palette[2], palette[3], Font)
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
		local fullscreen = love.window.getFullscreen( )
		love.window.setFullscreen(not fullscreen)
		local newW, newH = love.graphics.getDimensions() 
		local scaleW, scaleH = funct.scaler(state.BASIC_W, state.BASIC_H, newW, newH)

		state.scaleW, state.scaleH = scaleW, scaleH
	end
	
	if key == 'escape' then
		love.event.quit()
	end
	
	if key == 'f12' then
		visDbg = not visDbg
	end
end

function love.resize()
	
end

function love.quit()
	game:quit()
end
