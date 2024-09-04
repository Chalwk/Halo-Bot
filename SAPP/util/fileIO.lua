local fileIO = {}
local path = "./Halo-Bot/halo-events.json"

function fileIO:getJSONData()
    local file = io.open(path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return self.json:decode(content)
    end
end

function fileIO:setJSONData(content)
    local file = io.open(path, "w")
    if file then
        file:write(self.json:encode_pretty(content))
        file:close()
    end
end

function fileIO:getEventTable(event)
    return self[self.server_id]["EVENT_SETTINGS"][event]
end

function fileIO:addSAPPEvent(parent_table, args)
    local events = parent_table['sapp_events']
    table.insert(events, {
        title = args.title,
        description = args.description,
        color = args.color,
        channel = args.channel
    })
    return events
end

return fileIO