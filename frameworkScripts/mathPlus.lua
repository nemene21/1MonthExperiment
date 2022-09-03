--------------------------MISC

function lerp(a,b,c) return a+(b-a)*c end -- A + (B - A) * C

function clamp(n,min,max) -- Holds a number between two threasholds
    if n < min then n = min end
    if n > max then n = max end
    return n
end

function wrap(n,min,max) -- Wraps a number around two threasholds
    if n < min then n = max end
    if n > max then n = min end
    return n
end

function round(a) return math.floor(a+0.5) end -- floor(A + 0.5)

function floorSnap(a,b) return math.floor(a/b)*b end -- floor(A / B) * B
function snap(a,b) return round(a/b+0.5)*b end -- round(A / B) * B

function boolToInt(booleon)
    if booleon then return 1 end
    return 0
end
--------------------------PHYSICS

function newRect(x,y,w,h) return {x=x,y=y,w=w,h=h,touching=newVec(0,0)} end -- Make a new rect

function isRectColliding(rect,R) -- Return if two rects are touching
    return R.x + R.w * 0.5 > rect.x - rect.w * 0.5 and R.x - R.w * 0.5 < rect.x + rect.w * 0.5 and R.y + R.h * 0.5 > rect.y - rect.h * 0.5 and R.y - R.h * 0.5 < rect.y + rect.h * 0.5
end

function checkCollisions(rect,collidesWith) 
    local collided = {}

    -- Loop trough every rect you want to check collision with, if they are touching, add it to a list, return the list
    for id,R in pairs(collidesWith) do
        if isRectColliding(rect,R) then
            table.insert(collided,R)
        end
    end
    return collided
end

function moveRect(rect,motion,collidesWith)
    -- Reset touching
    rect.touching = newVec(0,0)

    -- Move x
    rect.x = rect.x + motion.x * dt

    -- Get rects colliding
    local collided = checkCollisions(rect,collidesWith)

    -- Clamp rect according to the collided rects boundries
    for id,R in pairs(collided) do
        if motion.x < 0 then
            rect.x = R.x + R.w * 0.5 + rect.w * 0.5; rect.touching.x = -1
        else if motion.x > 0 then
            rect.x = R.x - R.w * 0.5 - rect.w * 0.5; rect.touching.x = 1
        end end
    end

    -- Move y
    rect.y = rect.y + motion.y * dt

    -- Get rects colliding
    local collided = checkCollisions(rect,collidesWith)
    
    -- Clamp rect according to the collided rects boundries
    for id,R in pairs(collided) do
        if motion.y < 0 then
            rect.y = R.y + R.h * 0.5 + rect.h * 0.5; rect.touching.y = -1
        else if motion.y > 0 then
            rect.y = R.y - R.h * 0.5 - rect.h * 0.5; rect.touching.y = 1
        end end
    end

    return rect
end

-- Draw cool debug rects
function drawCollider(collider)
    setColor(0,0,255,50)
    love.graphics.rectangle("fill",collider.x - camera[1] - collider.w * 0.5, collider.y - camera[2] - collider.h * 0.5 ,collider.w,collider.h)
    setColor(0,0,255,255)
end

function drawColliders(colliders)
    for id,C in pairs(colliders) do
        drawCollider(C)
end end

-- Rayccast
function castRay(startPoint, wantedEndPoint, objects, positionFunction, radiusFunction, tilemap)

    positionFunction = positionFunction or getPositionXY

    if tilemap == nil then

        tilemap = newTilemap(nil, 48, {})

    end

    local difference = newVec(wantedEndPoint.x - startPoint.x, wantedEndPoint.y - startPoint.y)

    local move = newVec(difference.x, difference.y)
    move:normalize()

    move.x = move.x * 2; move.y = move.y * 2

    local point = newVec(startPoint.x, startPoint.y)

    for pointOn = 0, math.floor(difference:getLen() * 0.5) do

        point.x = point.x + move.x
        point.y = point.y + move.y

        if tilemap:getTile(math.floor(point.x / tilemap.tileSize), math.floor(point.y / tilemap.tileSize)) ~= nil then

            return nil, point

        else

            for id, object in ipairs(objects) do

                local objectPosition = positionFunction(object)

                if newVec(objectPosition.x - point.x, objectPosition.y - point.y):getLen() < radiusFunction(object) then
                    
                    return object, point

                end
    
            end

        end

    end

    return nil, wantedEndPoint
 
end

-- Get position from various objects position
function getPositionCollider(obj)

    return newVec(obj.collider.x, obj.collider.y)

end

function getPositionXY(obj)

    return newVec(obj.x, obj.y)

end

function getPositionPos(obj)

    return newVec(obj.pos.x, obj.pos.y)

end

--------------------------VECTORS
function newVec(x,y) --Makes new table with x and y
    return {x=x or 0,y=y or 0,getRot=getRot,getLen=getLen,normalize=normalize,rotate=rotate}
end

function getRot(vec) --Do not flip y for some reason, and turn radiens returned to degrees
    return math.atan2(vec.y,vec.x)/math.pi*180
end

function getLen(vec) --Pythagorean theorem (x=a, y=b, len=c, c = sqrt(a^2 + b^2)
    return math.sqrt(vec.x*vec.x+vec.y*vec.y)
end

function normalize(vec) -- Axis / lenght
    local len = getLen(vec)
    if len > 0 then
        vec.x = vec.x / len; vec.y = vec.y / len
    end
    return vec
end

function rotate(vec,angle)

    --Turn degrees to radiens
    local angle = angle * math.pi / 180

    --X = X*cos(ang) - Y*sin(ang), Y = X*sin(ang) + Y*cos(ang)
    local X = vec.x*math.cos(angle) - vec.y*math.sin(angle)
    local Y = vec.x*math.sin(angle) + vec.y*math.cos(angle)

    --set values
    vec.x = X; vec.y = Y
    return vec
end