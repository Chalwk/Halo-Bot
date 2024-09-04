local event = {}

function event:on_start()

    self.map = get_var(0, '$map')

    if get_var(0, '$gt') == 'n/a' then
        return
    end

    self.players = {}
end

register_callback(cb['EVENT_GAME_START'], 'on_start')

return event
