return {
    ["server_1"] = {

        STATUS_SETTINGS = {
            channelID = "1280417571837055022",
            serverName = "LNZ DEV SERVER",
            serverIP = "127.0.0.1:2310"
        },

        EVENT_SETTINGS = {
            ["EVENT_GAME_START"] = {
                title = "🌄 A new game has started!",
                description = "Map: [$map] - [$mode] with $total_players players.",
                color = "GREEN",
                channel = "1280417571837055022"
            },
            ["EVENT_GAME_END"] = {
                title = "🌅 The game has ended!",
                description = "The game ended with $total_players players.",
                color = "RED",
                channel = "1280417571837055022"
            }
        }
    }
}