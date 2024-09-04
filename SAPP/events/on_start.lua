local Event = {}

function Event:on_start()
    if get_var(0, '$gt') == 'n/a' then
        return
    end

    self.map = get_var(0, '$map')
    self.mode = get_var(0, '$mode')
    self.players = {}

    local playerList, totalPlayers = self:getPlayers()

    self.db[self.server_id].status["Map"] = self.map
    self.db[self.server_id].status["Mode"] = self.mode
    self.db[self.server_id].status["Total Players"] = totalPlayers
    self.db[self.server_id].status["Player List"] = playerList

    local event = self:getEventTable("EVENT_GAME_START")
    local t = self:addSAPPEvent(self.db[self.server_id], {
        title = self:formatMessage(event.title),
        description = self:formatMessage(event.description),
        color = event.color,
        channel = event.channel
    })

    self.db[self.server_id].sapp_events = t
    self:setJSONData(self.db)
end

register_callback(cb['EVENT_GAME_START'], 'on_start')

return Event
