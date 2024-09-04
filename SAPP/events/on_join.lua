local event = {}

function event:on_join(playerId)
    self.players[playerId] = self:newPlayer({
        ip = get_var(playerId, '$ip'),
        name = get_var(playerId, '$name')
    })
end

register_callback(cb['EVENT_JOIN'], 'on_join')

return event