
events = {}

function event(type, data)

    table.insert(events, {type = type, data = data})

end

function iterateEvents(func, type)

    for id, event in ipairs(events) do

        if event.type == (type or event.type) then
            
            func(event)

        end

    end

end