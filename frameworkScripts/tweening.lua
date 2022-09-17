
function easeOutBack(a, b, t)

    local c1 = 1.70158
    local c3 = 2.70158

    local animValue = 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)

    return lerp(a, b, animValue)

end

function easeInBack(a, b, t)

    local c1 = 1.70158
    local c3 = 2.70158

    local animValue = c3 * t * t * t - c1 * t * t

    return lerp(a, b, animValue)

end

function easeInOutQuad(a, b, t)

    local animValue = nil
    
    if t < 0.5 then
        
        animValue = 2 * t * t
        
    else
        
        animValue = 1 - math.pow(-2 * t + 2, 2) / 2

    end

    return lerp(a, b, animValue)

end

c4 = (2 * math.pi) / 3

function easeOutElastic(a, b, t)
    
    local animValue = nil

    if t == 0 then
        
        animValue = 0

    else
        
        if t == 1 then
            
            animValue = 1

        else
            
            animValue = math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * c4) + 1

        end

    end

    return lerp(a, b, animValue)

end
