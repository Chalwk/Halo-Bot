local event = {}

function event:on_tick()

end

register_callback(cb['EVENT_TICK'], 'on_tick')

return event