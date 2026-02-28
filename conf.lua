scaleW = 1
scaleH = 1

def_width = 800
def_height = 640

cell = 20
BG_COLOR = {.88,.90,.92}

function love.conf(t)
    t.identity = 'Mini Snake'
    t.appendidentity = false
    t.version = "11.3"
    t.console = false 

    t.window.title = "Snake"
    t.window.icon = nil
    t.window.width = def_width * scaleW
    t.window.height = def_height * scaleH
    t.window.resizable = false
    t.window.minwidth = def_width
    t.window.minheight = def_height
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1 
end
