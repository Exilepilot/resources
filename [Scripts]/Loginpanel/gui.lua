--[[

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 

 Copyright (C) 2014 Pilot <ricky@friendsconnect.nl>

 Everyone is permitted to copy and distribute verbatim or modified 
 copies of this license document, and changing it is allowed as long 
 as the name is changed. 

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 

  0. You just DO WHAT THE FUCK YOU WANT TO.

--]]

gui = {
    label = {},
    edit = {},
    visible = false,
    --[[
        Button changes color depending on certain things such as:
            - Incorrect login (username or password),   -- Red
            - Both passwords aren't the same whilst registering.    -- Yellow
            - Username already exists, etc. -- Yellow
            - Everything is up to standard, no problems -- Green

            Therefore: 
                Green - indicates it's good to register or login.
                Yellow - indicates that you need to recheck things before logging in.
                Red - You cannot login or register until instructions are followed.
    --]] 
    dxbutton = {
        hovered = false,
        clicked = false,
        shadowalpha = 0,
        color = 0,  -- 0 - Green, 1 -- Amber(yellow), 2 -- Red
        -- Color = {color, darkercolor}
        ["0"] = {
            {0, 157, 0},
            {0, 132, 0},
        },
        -- Actually orange...
        ["1"] = {
            {240, 142, 37},
            {211, 116, 15},
        },

        ["2"] = {
            {230, 0, 0},
            {205, 0, 0},
        },
    },

    toggleMode = false,     -- false => login, true => register
    labelText = {"Click me to register!","Click me to login!"},
    buttonText = {"LOGIN", "REGISTER"}
}

gui.index = gui
local screenW, screenH = guiGetScreenSize()
--
function X( p )
    return p / 1366 * screenW
end
 
function Y( p )
    return p / 768 * screenH
end

---------------------------------------------------------------------------------
-- Setting up GUI
---------------------------------------------------------------------------------
guiSetInputMode("no_binds_when_editing")

gui.label[1] = guiCreateLabel(0.434,0.652,0.132,0.046,"LOGIN", true)
guiSetFont(gui.label[1], "default-bold-small")
guiLabelSetHorizontalAlign(gui.label[1], "center", false)
guiLabelSetVerticalAlign(gui.label[1], "center", false)

gui.label[2] = guiCreateLabel(0.45, 0.29, 0.11, 0.02, "Who are you?", true)
guiSetFont(gui.label[2], "default-bold-small")
--guiLabelSetColor(gui.label[2], 2, 1, 1)
guiLabelSetHorizontalAlign(gui.label[2], "center", false)


gui.label[3] = guiCreateLabel(0.35, 0.32, 0.30, 0.02, gui.labelText[1], true)
guiSetFont(gui.label[3], "default-bold-small")
-- 196, 2, 2
guiLabelSetColor(gui.label[3], 255,255,255)
guiLabelSetHorizontalAlign(gui.label[3], "center", false)


gui.edit[1] = guiCreateEdit(0.42, 0.40, 0.17, 0.04, "", true)
gui.edit[2] = guiCreateEdit(0.42, 0.48, 0.17, 0.04, "", true)
gui.edit[3] = guiCreateEdit(0.42, 0.56, 0.17, 0.04, "", true)


guiEditSetMasked(gui.edit[2], true)
guiEditSetMasked(gui.edit[3], true)

-- Make them invisible on startup.
for i = 1, 3 do
    guiSetVisible(gui.edit[i], false)
    guiSetVisible(gui.label[i], false)
end

addEventHandler("onClientRender", root,
    function()
        if gui.visible then
            dxDrawRectangle(X(403), Y(222.5), X(560), Y(323), tocolor(30, 30, 30, 255), false)

            dxDrawText("Password",  X(567), Y(347), X(799), Y(370), tocolor(255, 255, 255, 255), 1.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("Username", X(567), Y(285), X(799), Y(308), tocolor(255, 255, 255, 255), 1.00, "pricedown", "center", "center", false, false, false, false, false)
            if gui.toggleMode then
                dxDrawText("Repeat",  X(567), Y(409), X(799), Y(432), tocolor(255, 255, 255, 255), 1.00, "pricedown", "center", "center", false, false, false, false, false)
            end
            dxDrawRectangle(X(397), Y(218), X(570), Y(22), tocolor(0, 0, 0, 255), false)
            dxDrawRectangle(X(397), Y(218), X(570), Y(22), tocolor(205, 0, 0, 250), false)
            dxDrawRectangle( X(592) , Y(495) , X(180), Y(35), tocolor(0,0,0,gui:getButtonShadowAlpha()), false)    -- Get shadow of button.
            dxDrawRectangle(X(597), Y(501) ,X(180), Y(35), gui:getButtonColor(), false)
        end
    end
)


bindKey("F5", "down", 
    function()
        outputDebugString("gui:isVisible => "..tostring(gui:isVisible()))
        setTimer(
            function()
                gui.visible = (not gui:isVisible())
                gui:toggle(gui.visible)
            end, 200, 1
        )
    end)

function gui:isVisible()
    return self.visible
end

function gui:getDataFromEdit()
    local user, pass, rpass = guiGetText(gui.edit[1]), guiGetText(gui.edit[2]),guiGetText(gui.edit[3])
    return user, pass, rpass
end

function gui:warning(message)
    local msg = message or nil
    if msg ~= nil then
        guiSetText(self.label[3], message)
        self.dxbutton.color = 2
        local t = 
            function()
                guiSetText(self.label[3], self.labelText[self:getDefaultText()])
                self.dxbutton.color = 0
            end
        setTimer(t, 1500, 1)
        return 
    end
end
addEvent("gui:warning", true)
addEventHandler("gui:warning", getRootElement(),
    function(msg)
        gui:warning(msg)
    end)
function gui:toggle(bool)
    local k,j = 2, 1
    for i = 1, 3 do
        guiSetVisible(self.label[i], bool)
    end
    if gui.toggleMode then
        j = 2
        k = 3
    end

    self.dxbutton.color = (self.dxbutton.color == 1) and (self.dxbutton.color == 2) or 0
    guiSetText(gui.label[3], gui.labelText[j])

    for i = 1, k do
        guiSetVisible(self.edit[i], bool) 
    end
    showCursor(bool)
    return
end

addEvent("gui:toggle", true)
addEventHandler("gui:toggle", getRootElement(),
    function()
        setTimer(
            function()
                gui.visible = (not gui:isVisible())
                gui:toggle(gui.visible)
            end, 200, 1
        )
    end)

-- Get button colour (color is quicker to write, fucking Americans...)
function gui:getButtonColor()
    local t = self.dxbutton[tostring(self.dxbutton.color)]
    if self.dxbutton.hovered then
        guiLabelSetColor(self.label[1],173, 173, 173)
        local r,g,b = t[2][1], t[2][2], t[2][3]
        return tocolor(r,g,b,255)
    else
        guiLabelSetColor(self.label[1], 255,255,255)
        local r,g,b = t[1][1], t[1][2], t[1][3]
        return tocolor(r,g,b, 255)
    end
end

function gui:getButtonShadowAlpha()
    return gui.dxbutton.shadowalpha
end

function gui:getDefaultText()
    if gui.toggleMode then
        return 2
    else
        return 1
    end 
end

function gui:modeToggle()
    self.toggleMode = not self.toggleMode
    guiSetText(self.label[3], self.labelText[self:getDefaultText()] )
    guiSetText(self.label[1], self.buttonText[self:getDefaultText()])
    guiSetVisible(self.edit[3], self.toggleMode)
    guiSetText(self.edit[1], "")
    guiSetText(self.edit[2], "")
    guiSetText(self.edit[3], "")
    self.dxbutton.color = 0
end

addEvent("gui:modeToggle", true)
addEventHandler("gui:modeToggle",getRootElement(),
    function()
        local t = function() gui:modeToggle() end
        setTimer(t,200, 1) 
    end)
--------------------------------------------------------
-- LOGIN / REGISTER functions
--------------------------------------------------------

--------------------------------------------------------
-- Change button color on hover.
--------------------------------------------------------
addEventHandler("onClientMouseEnter", gui.label[1],
    function()
        gui.dxbutton.hovered = true
    end, false)

addEventHandler("onClientMouseLeave", gui.label[1],
    function()
        gui.dxbutton.hovered = false
    end, false)
------------------------------------------------------
-- Change label color on mouse hover
------------------------------------------------------
addEventHandler("onClientMouseEnter", gui.label[3], 
    function()
        local i = guiGetText(gui.label[3])
        if i == gui.labelText[1] or i ==  gui.labelText[2] then
            guiLabelSetColor(gui.label[3], 0, 157, 0 )
        end
    end, false)
addEventHandler("onClientMouseLeave", gui.label[3],
    function ()
        local i = guiGetText(gui.label[3])
        if i == gui.labelText[1] or i == gui.labelText[2] then
            guiLabelSetColor(gui.label[3], 255,255,255)
        end
    end, false)
addEventHandler("onClientGUIClick", gui.label[3],
    function ()
        local i = guiGetText(gui.label[3])
        if i == gui.labelText[1] or i == gui.labelText[2] then
            local t = function ()
                gui:modeToggle()
            end

            setTimer(t, 200, 1)
        end
    end, false)

-- Fade the shadow out on release
addEventHandler("onClientGUIClick", gui.label[1],
    function()
        gui.dxbutton.shadowalpha = 100
        setTimer(
            function()
                --gui.dxbutton.shadowalpha
                while gui.dxbutton.shadowalpha ~= 0 do
                    gui.dxbutton.shadowalpha = gui.dxbutton.shadowalpha - 1
                end
            end, 100, 1)

        -- REGISTER FUNCTION HERE: 
        local user, pass, rpass = gui:getDataFromEdit()

        if gui.toggleMode then
            if #user > 0 and #pass > 4 then
                if pass == rpass then
                    triggerServerEvent("server:register", localPlayer, user, pass)
                else
                    gui:warning("Passwords must be the same")
                end
            elseif not (#user == 0 and #pass == 0) then 
                gui:warning("Password must have 5 or more characters!")
            end
        else
            if #user > 0 and #pass > 0 then
                triggerServerEvent("server:login", localPlayer, user, pass)
            end
        end
    end, false)

addEventHandler("onClientCharacter", root,
    function()
        local k = function()
            if gui.visible and gui.toggleMode then
                local user,pass,rpass = gui:getDataFromEdit()
                if #user > 0 and #pass > 4 then
                    if pass == rpass then
                        gui.dxbutton.color = 0
                    else
                        gui.dxbutton.color = 1
                    end
                else
                    gui.dxbutton.color = 2
                end
            end
        end
        if gui.toggleMode then
            guiSetText(gui.label[3], "Password must have 5 or more characters.")
            setTimer(k, 500, 1)
        end
    end)