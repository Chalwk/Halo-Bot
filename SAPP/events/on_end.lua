local Event = {}

function Event:on_end()

    local event = self:getEventTable("EVENT_GAME_END")
    local t = self:addSAPPEvent(self.db[self.server_id], {
        title = self:formatMessage(event.title),
        description = self:formatMessage(event.description),
        color = event.color,
        channel = event.channel
    })

    self.db[self.server_id].sapp_events = t
    self:setJSONData(self.db)
end

register_callback(cb['EVENT_GAME_END'], 'on_end')

return Event
