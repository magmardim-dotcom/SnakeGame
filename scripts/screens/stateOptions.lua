return Modules.Menu:new(
	{
		offsetY = 150,
		width = state.BASIC_W,
		height = state.BASIC_H,
		strings = {
		[1] = {
			nam = function(s)
				return string.format("палитра: %d", state.palette)
			end,
			right = function(s)					
				if state.palette + 1 <= #PaletteList then state.palette = state.palette + 1 else state.palette = 1 end
			end,
			left = function(s)						
				if state.palette - 1 >= 1 then state.palette = state.palette - 1 else state.palette = #PaletteList end
			end
		},
		[2] = {
			nam = function(s)
				return string.format("полноэкранный режим: %s", state.fullScreen and "да" or "нет")
			end,
			right = function(s)					
				funct.fullScreen(not state.fullScreen)				
			end,
			left = function(s)						
				funct.fullScreen(not state.fullScreen)
			end,
			act = function(s)
				funct.fullScreen(not state.fullScreen)
			end,
		},
		[3] = {
			nam = function(s)
				return string.format("музыка: %s", state.musicPlay and "да" or "нет")
			end,
			right = function(s)					
				state.musicPlay = not state.musicPlay
			end,
			left = function(s)						
				state.musicPlay = not state.musicPlay
			end,
			act = function(s)
				state.musicPlay = not state.musicPlay
			end,
		},
		[4] = {
			nam = function(s)
				return string.format("громкость: %.1f", state.musicVol)
			end,
			right = function(s)					
				if state.musicVol + .1 <= 1 then state.musicVol = state.musicVol + .1 end
				love.audio.setVolume(state.musicVol)
			end,
			left = function(s)						
				if state.musicVol - .1 > 0.1 then state.musicVol = state.musicVol - .1 end
				love.audio.setVolume(state.musicVol)
			end,
		},
		[5] = {
			nam = "назад", 
			act = function(s) 
				funct.switchScreen('title') 
			end},
		}
	}
)
