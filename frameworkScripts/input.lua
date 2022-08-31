
-- KEYBOARD

lastKeyPressed = "none"
-- Keyboard input
function pressed(string) return love.keyboard.isDown(string) end -- Returns if a key is pressed (just for consistency XD)

function justPressed(string) return lastKeyPressed == string end -- Returns if a key is pressed at that frame.

-- Updating the input (unimportant, not for use)
function setJustPressed(string) lastKeyPressed = string end

-- MOUSE

lastMouseButtonPressed = -1

function mousePressed(button) return love.mouse.isDown(button) end -- Returns if a key is pressed (just for consistency XD)

function mouseJustPressed(button) return lastMouseButtonPressed == button end -- Returns if a key is pressed at that frame.

-- Updating the input (unimportant, not for use)
function setMouseJustPressed(button) lastMouseButtonPressed = button end

-- JOYSTICK

function joystickPressed(id,button) return JOYSTICKS[id]:isGamepadDown(button) end

function joystickJustPressed(id,button) return JOYSTICK_LAST_PRESSES[id] == button end

function joystickGetAxis(id,axis)

    if idInTable(JOYSTICKS,id) then
    axis = axis * 2

    local x = JOYSTICKS[id]:getAxis(axis - 1)
    local y = JOYSTICKS[id]:getAxis(axis)

    return newVec(x,y)
    end

    return 0
end