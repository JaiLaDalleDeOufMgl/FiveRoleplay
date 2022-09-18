Package.Log("Loading Five RôlePlay Server Version 0.0.3-alpha")

local open = false

local Menu = WebUI("Menu", "file://Menu/index.html",true)

Input.Register("Menu", "F1")

Input.Bind("Menu", InputEvent.Pressed, function()
    if not open then
        open = true
        Client.SetMouseEnabled(true)
        Menu:CallEvent('open')
    elseif open then
        open = false
        Client.SetMouseEnabled(false)
        Menu:CallEvent('close')
    end
end)

if Config.EnableDefautlHud then
    local Hud = WebUI("Hud", "file://Hud/index.html",true)

    Hud:CallEvent('Infos', 'Bruno', "DelPero", "Civil", "RSA", 1000, 75, 25, 100)
end