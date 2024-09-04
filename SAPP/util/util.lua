local Util = {}

function Util:formatMessage(message)
    for k, v in pairs({
        ["$map"] = self.map,
        ["$mode"] = self.mode,
        ["$total_players"] = tonumber(get_var(0, "$pn"))
    }) do
        message = message:gsub(k, v)
    end
    return message
end

function Util:getPlayers()
    local totalPlayers = tonumber(get_var(0, "$pn"))
    local playerList = {}
    for i = 1, 16 do
        if player_present(i) then
            table.insert(playerList, get_var(i, "$name"))
        end
    end
    return playerList, totalPlayers
end

return Util