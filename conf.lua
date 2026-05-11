function love.conf(t)
    t.identity = 'Snake'
    t.appendidentity = false
    t.version = "11.3"
    t.console = false 

    t.window.title = "Snake"
    t.window.icon = nil
    t.window.width = 1000
    t.window.height = 640
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1 
    --~ t.window.fullscreentype = 'exclusive'
end
