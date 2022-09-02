
camera = {0,0}; boundCamPos = {0,0}

lerpSpeed = 6

shakeStr = 0; shakes = 0; shakeTimer = newTimer(0); dir = nil; screenshake = {0,0}
lastScreenshake = {0,0}; boundScreenshake = {0,0}

-- Camera

lastPriority = 0

function bindCamera(x,y, priority)
    if priority or 1 > lastPriority then

        boundCamPos = {x - WS[1] * 0.5, y - WS[2] * 0.5}
        lastPriority = priority

    end
end

function processCamera()
    lastPriority = 0
    
    shakeTimer:process()

    if shakeTimer:isDone() then

        if shakes > 0 then

            lastScreenshake = deepcopyTable(boundScreenshake)

            shakes = shakes - 1

            shakeTimer:reset()

            if dir == nil then

                boundScreenshake = {love.math.random(-shakeStr,shakeStr),love.math.random(-shakeStr,shakeStr)}

            else

                local screenshakeTemp = newVec(love.math.random(shakeStr * 0.5,shakeStr), 0); screenshakeTemp:rotate(dir)
                boundScreenshake = {screenshakeTemp.x, screenshakeTemp.y}

            end

        else

            shakeStr = 0; boundScreenshake = {0,0}; dir = nil; lastScreenshake = {0,0}

        end
    end

    camera[1] = lerp(camera[1],boundCamPos[1], dt*lerpSpeed)
    camera[2] = lerp(camera[2],boundCamPos[2], dt*lerpSpeed)
    
    screenshake[1] = boundScreenshake[1] * math.sin(3.14 * shakeTimer.time / shakeTimer.timeMax)
    screenshake[2] = boundScreenshake[2] * math.sin(3.14 * shakeTimer.time / shakeTimer.timeMax)

end

-- Screenshake

function shake(shakeStrNew,shakesNew,time,dir)

    dir = dir or nil

    if shakeStr < shakeStrNew then

        shakeStr = shakeStrNew; shakes = shakesNew; shakeTimer.timeMax = time; shakeTimer.time = 0; dir = dir
    end
end

function lockScreenshake(bool) shakeTimer.playing = bool end

shake(16, 1, 0.01)