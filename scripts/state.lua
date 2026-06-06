local state = {}

state.MENU_HEIGHT = 40
state.BASIC_FONT = "resurses/font/PeppaPigW1G-Regular.ttf"
state.FONT_SIZE = 52
state.FONT2_SIZE = 24
state.BASIC_W = 1120
state.BASIC_H = 640
state.CELL = 20
state.TXT_COLOR = {0,0,1}
state.SEL_COLOR = {1,0,0}
state.scaleW = 1
state.scaleH = 1
state.FPS = 60
state.next_time = love.timer.getTime()

function state:limitFPS()
	local cur_time = love.timer.getTime()
	
	self.next_time = self.next_time + 1/self.FPS
	
	if self.next_time <= cur_time then
		self.next_time = cur_time
		return
	end
	love.timer.sleep(self.next_time - cur_time)
end

-- options
state.palette = 3
state.musicPlay = true
state.musicVol = 1
state.fullScreen = false

return state
