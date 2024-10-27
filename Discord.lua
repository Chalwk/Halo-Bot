--[[

   Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details.

Description:
    This script serves as a custom bridge between Halo 1 (PC/CE) and Discord, enhancing the gaming experience by
    keeping your Discord community up-to-date with in-game events. It sends customizable event notifications to
    Discord channels, making it easy for server members to stay informed about what's happening in the game.

Events:
    EVENT                   | TRIGGERED WHEN:
    :---------------------- | :----------------
    event_chat              | A player sends a chat message
    event_command           | A player executes a command
    event_game_start        | A new game starts
    event_game_end          | A game ends
    event_join              | A player joins the server
    event_leave             | A player leaves the server
    event_die               | A player dies
    event_snap              | A player snaps
    event_spawn             | A player spawns
    event_login             | A player logs in
    event_team_switch       | A player switches teams
    event_score             | A player scores
    script_load             | This script is loaded
    script_unload           | This script is unloaded
    event_map_reset         | The map is reset

Key Features:
    * Real-time notifications for various in-game events
    * Customizable embed messages, including title, description, color, and designated channel
	* Enable/disable specific events

Coming in future updates:
    * Two-way text communication between Discord and Halo (chat relay).
        This feature will allow players to send messages from Discord to the game and vice versa.
        Currently, only game events are sent to Discord.
    * Support to execute SAPP commands from Discord.
        This feature will allow server admins to execute SAPP commands from Discord.
    * Support for custom event notifications.
        This feature will allow server admins to create custom event notifications for specific events.
]]--

local config = {

    -- General settings:

    -- Unique identifier for this specific server
    -- Used to store data for multiple servers in a single JSON file.
    -- Must be changed and kept unique if you are running multiple halo servers.
    -- Not strictly required if you are running a single server, in which case you can leave it as is.
    serverID = "server_1",

    -- Default color for embed messages
    -- Available colors: "GREEN", "BLUE", "RED", "YELLOW", etc.
    defaultColor = "GREEN",

    -- Format for displaying timestamps in messages
    -- Formatting options are similar to the C library function `strftime()`
    timeStampFormat = "%A %d %B %Y - %X",

    -- Status settings:
    -- These settings control how the bot updates the server status message in Discord.
    status = {

        title = "🌐 Server Status",
        description = "Real-time status updates of the server.\nThis status is dynamically updated every 30 seconds.",

        --
        -- [!] NOTE: All field values except the "Server IP" are updated dynamically, so do not change them.
        --

        fields = {
            {
                name = "🏷️ Server Name", -- you can change this
                value = "N/A",
                inline = false
            },
            {
                name = "📍 Server IP", -- you can change this
                value = "FILL THIS IN MANUALLY", -- change this to your server IP:PORT
                inline = false
            },
            {
                name = "🗺️ Map", -- you can change this
                value = "N/A",
                inline = false
            },
            {
                name = "⚙️ Mode", -- you can change this
                value = "N/A",
                inline = false
            },
            {
                name = "👥 Total Players", -- you can change this
                value = "N/A",
                inline = false
            },
            {
                name = "👤 Player List", -- you can change this
                value = "N/A",
                inline = false
            }
        },

        -- The color of the embed message:
        color = "BLUE",

        -- The channel ID where the bot will update the server status message:
        channel = "1283163771287765045"
    },

    --------------------------------
    -- End of general settings --
    --------------------------------

    -- Available colors for embed messages:
    -- RED, BLUE, GREEN, YELLOW, ORANGE, CYAN, MAGENTA, PINK, WHITE, BLACK, GRAY, DARK_GRAY, LIGHT_GRAY

    -- Embed format:
    -- enabled (boolean):       Whether the event notification is enabled
    -- title (string):          The title of the embed message
    -- description (string):    The description of the embed message
    -- color (string):          The color of the embed message
    -- channel (string):        The channel ID where the embed message will be sent

    -- Event-specific settings:
    events = {
        -- Available placeholders: $map, $mode, $faa
        ["OnStart"] = {
            enabled = true,
            title = "🌄 A new game has started!",
            description = "- Map: [**$map**]\n- Mode: [**$mode**] (**$faa**)",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $map, $mode, $totalPlayers, $faa
        ["OnEnd"] = {
            enabled = true,
            title = "🌅 Game Concluded!",
            description = "Game finished with a total of **$totalPlayers** players.",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers, $playerID
        ["OnJoin"] = {
            enabled = true,
            title = "🟢 Player Joined!",
            description = "**$playerName** has connected to the server!\nCurrent players online: **$totalPlayers**",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers, $playerID
        ["OnQuit"] = {
            enabled = true,
            title = "🔴 Player Left!",
            description = "**$playerName** has disconnected from the server.\nActive players remaining: **$totalPlayers**",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $playerName, $playerID
        ["OnSpawn"] = {
            enabled = false,
            title = "🐣 $playerName has spawned!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $playerName, $team, $playerID
        ["OnSwitch"] = {
            enabled = true,
            title = "👥 Team Switch Alert!",
            description = "**$playerName** switched to the **$team** team.",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $playerName, $playerID
        ["OnWarp"] = {
            enabled = true,
            title = "𒅒 $playerName is warping...",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $map, $mode
        ["OnReset"] = {
            enabled = true,
            title = "🔄 The map has been reset!",
            description = "- **$map**\n- **$mode**",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $playerName, $playerID
        ["OnLogin"] = {
            enabled = false,
            title = "👤 Login Notification!",
            description = "**$playerName** has successfully logged in.",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $playerName, $playerID
        ["OnSnap"] = {
            enabled = false,
            title = "⊹ $playerName snapped!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $type, $name, $id, $command, $playerID
        ["OnCommand"] = {
            enabled = false,
            title = "⌘ Command Executed!",
            description = "**[Command Type: $type]** `$playerName` **(ID: $id)** issued the command: `$command`",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- Available placeholders: $type, $playerName, $id, $message, $playerID
        ["OnChat"] = {
            enabled = true,
            title = "🗨️ New Chat Message",
            description = "**[Type: $type]** `$playerName` **(ID: $id)**: *$message*",
            color = "BLUE",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnScore"] = {
            [1] = {
                -- Available placeholders: $playerName, $playerTeam, $redScore, $blueScore
                enabled = true,
                title = "🏆 CTF Scoreboard update!",
                description = "**$playerName** captured the flag for the **$playerTeam** team!\n\n🟥 Red Score: **$redScore**\n🟦 Blue Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $playerTeam, $lapTime, $totalTeamLaps
            [2] = {
                enabled = true,
                title = "🏆 Team RACE Scoreboard updated!",
                description = "**$playerName** completed a lap for **$playerTeam**!\n\n⏱ Lap Time: **$lapTime**\n🏁 Team Total Laps: **$totalTeamLaps**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $lapTime, $playerScore
            [3] = {
                enabled = true,
                title = "🏆 FFA RACE Scoreboard updated!",
                description = "**$playerName** finished a lap.\n\n⏱ Lap Time: **$lapTime**\n🏆 Total Laps Completed: **$playerScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $playerTeam, $redScore, $blueScore
            [4] = {
                enabled = true,
                title = "🏆 Team Slayer Scoreboard updated!",
                description = "**$playerName** scored for **$playerTeam** team!\n\n🟥 Red Score: **$redScore**\n🟦 Blue Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $redScore, $blueScore
            [5] = {
                enabled = true,
                title = "🏆 FFA Slayer Scoreboard updated!",
                description = "**$playerName** scored!\n\n🟥 Red Score: **$redScore**\n🟦 Blue Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            }
        },
        ["OnDeath"] = {
            -- Available placeholders: $killerName, $victimName, $killerID, $victimID
            [1] = {
                enabled = true,
                title = "☠️ First Blood!",
                description = "**$killerName** has drawn first blood!",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [2] = {
                enabled = true,
                title = "☠️ Beyond the Grave!",
                description = "**$victimName** was slain post-mortem by **$killerName**.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [3] = {
                enabled = true,
                title = "☠️ Vehicle Kill!",
                description = "**$victimName** was taken out by **$killerName** in a vehicle.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [4] = {
                enabled = true,
                title = "☠️ PvP Kill!",
                description = "**$victimName** fell to **$killerName** in combat.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [5] = {
                enabled = true,
                title = "☠️ Guardian Strike!",
                description = "**$victimName** was slain by the guardians.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [6] = {
                enabled = true,
                title = "☠️ Self-Elimination!",
                description = "**$victimName** met their end by their own hand.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [7] = {
                enabled = true,
                title = "☠️ Betrayal!",
                description = "**$victimName** was betrayed by **$killerName**.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [8] = {
                enabled = true,
                title = "☠️ Vehicle Collision!",
                description = "**$victimName** was squashed by a rogue vehicle.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [9] = {
                enabled = true,
                title = "☠️ Fatal Fall!",
                description = "**$victimName** took a fatal fall.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [10] = {
                enabled = true,
                title = "☠️ Server Elimination!",
                description = "**$victimName** was eliminated by the server.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [11] = {
                enabled = true,
                title = "☠️ Death Event",
                description = "**$victimName** has died.",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            }
        }
    }
}

api_version = '1.12.0.0'

-- Configuration ends here -----------------------------------------------------------------------
-- Do not edit below this line

local serverData, players = {}, {}

-- Path to the JSON Data file that will store all the events to be processed by the Discord Bot.
local jsonEventsPath = "./Halo-Bot/halo-events.json"

-- Path to the JSON library file
local jsonLibraryPath = "./Halo-Bot/json.lua"

local _pairs = pairs
local _open = io.open
local _date = os.date
local _clock = os.clock
local _tonumber = tonumber
local _insert = table.insert
local _concat = table.concat
local _floor = math.floor
local _format = string.format
local _char = string.char
local json = loadfile(jsonLibraryPath)()

local ffa, falling, distance, first_blood, map, mode, game_type

--- Reads the JSON data file and returns the decoded data as a Lua table.
-- @return Table|nil Decoded JSON data or nil if the file couldn't be read
local function getJSONData()
    local file = _open(jsonEventsPath, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return json:decode(content)
    end
    return nil
end

--- Updates the JSON data file with the provided Lua table and writes the encoded data to the file.
-- @param t Table The Lua table containing the updated data
local function updateJSONData(t)
    local file = _open(jsonEventsPath, "w")
    if file then
        file:write(json:encode_pretty(t))
        file:close()
    end
end

--- Initializes the server data with the provided server ID.
-- @param serverID String The unique server ID
local function initServerData()

    serverData = { sapp_events = {}, status = config.status }

    local jsonData = getJSONData() or {}
    jsonData[config.serverID] = serverData

    updateJSONData(jsonData)
end

--- Initializes the script by registering callbacks for various events and setting up the server status.
function OnScriptLoad()

    -- Register callbacks for various game events
    -- @param cb Table The callback table
    -- @param func Function The callback function for each event
    register_callback(cb['EVENT_CHAT'], 'OnChat')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')

    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')

    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    register_callback(cb['EVENT_SNAP'], 'OnSnap')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_LOGIN'], 'OnLogin')
    register_callback(cb['EVENT_MAP_RESET'], "OnReset")
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_SCORE'], 'OnScore')

    initServerData()

    -- Trigger OnStart with a new game event.
    -- This is necessary for the script to work properly if loaded during a game.
    OnStart(true)
end

--- Reads a wide string (UTF-16) from the specified address and returns it as a string.
-- @param Address The memory address where the wide string starts.
-- @param Length The length of the wide string in characters.
-- @return A string representing the wide string.
local function readWideString(Address, Length)
    local count = 0
    local byte_table = {}
    for i = 1, Length do
        if (read_byte(Address + count) ~= 0) then
            byte_table[i] = _char(read_byte(Address + count))
        end
        count = count + 2
    end
    return _concat(byte_table)
end

--- Gets the server name from the game memory.
-- @return The server name as a string, or "Waiting for server name..." if the name is not available.
local function getServerName()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local name = readWideString(network_struct + 0x8, 0x42)
    return name ~= "" and name or "Waiting for server name..."
end

--- Parses a message template and replaces placeholders with corresponding values from the given arguments.
-- @param String String The message template containing placeholders
-- @param args Table A key-value table with placeholders and values
-- @return String The parsed message with placeholders replaced by their corresponding values
local function parseMessageTemplate(String, args)
    local message = String
    for placeholder, value in _pairs(args) do
        message = message:gsub(placeholder, value)
    end
    return message
end

--- Calculates the total number of players on the server, taking into account whether a player has quit or not.
-- @param isQuit Boolean Indicates if a player has quit
-- @return number Total number of players
local function getTotalPlayers(isQuit)
    local total = _tonumber(get_var(0, "$pn"))
    return (isQuit and total - 1 or total)
end

--- Checks if the provided player should be excluded based on the event type and player ID.
-- @param isQuit Boolean Indicates whether it's a quit event
-- @param playerToCompare number The player to compare
-- @param playerToExclude number The player to exclude
-- @return boolean True if the player should be excluded, false otherwise
local function exclude(isQuit, playerToCompare, playerToExclude)

    if (not isQuit) then
        return false
    end

    return playerToCompare == playerToExclude
end

--- Formats the K/D ratio based on the number of kills and deaths.
-- @param kills number The number of kills
-- @param deaths number The number of deaths
-- @return string The formatted K/D ratio
local function getKDR(kills, deaths)
    return _format("%.2f", deaths > 0 and kills / deaths or kills)
end

--- Retrieves the score of the provided player based on the game type.
-- @param player Table A table representing the player
-- @return string The formatted score string
local function getScore(player)

    -- Retrieve basic information
    local score = get_var(player.id, "$score")
    local team = ffa and "FFA" or player.team:sub(1, 1):upper() .. player.team:sub(2)
    local kills = _tonumber(get_var(player.id, "$kills"))
    local deaths = _tonumber(get_var(player.id, "$deaths"))
    local kdr = getKDR(kills, deaths)

    local stringBuilder = "🛡️ | **Team**: " .. (team == "FFA" and "FFA" or "**" .. team .. "**") .. " | "

    if game_type == "ctf" then
        stringBuilder = stringBuilder .. "🏳️ **Flag Caps**: " .. score .. " | "
    elseif game_type == "race" then
        stringBuilder = stringBuilder .. "🏁 **Laps**: " .. score .. " | "
    else
        stringBuilder = stringBuilder .. "🏆 **Score**: " .. score .. " | "
    end

    stringBuilder = stringBuilder .. "⚔️ **Kills**: " .. kills .. " | ☠️ **Deaths**: " .. deaths .. " | 🎯 **K/D**: " .. kdr

    return stringBuilder
end


--- Retrieves a list of players currently on the server.
-- @return Table A table containing the names of all players on the server
local function getPlayerList(isQuit, excludeThisPlayer)

    local playerList = {}
    for i = 1, 16 do
        if player_present(i) then
            local player = players[i]
            if player and not exclude(isQuit, i, excludeThisPlayer) then
                local score = getScore(player)
                local line = "- **" .. player.name .. "** " .. score
                _insert(playerList, line)
            end
        end
    end

    return #playerList > 0 and _concat(playerList, "\n") or "No players online"
end

--- Retrieves the event configuration based on the provided event name and type.
-- @param eventName String The name of the event
-- @param eventType number The type of the event
-- @return Table|nil The event configuration if found, otherwise nil
local function getEventConfig(eventName, eventType)
    local event = config.events[eventName]
    local altEvent

    if eventName == "OnDeath" or eventName == "OnScore" then
        altEvent = event[eventType]
    end
    return altEvent and altEvent.enabled and altEvent or (event and event.enabled and event) or nil
end

--- Sends an event notification to Discord based on the provided event name and arguments.
-- @param eventName String The name of the event
-- @param args Table A key-value table containing event-specific arguments
local function notify(eventName, args)
    local eventConfig = getEventConfig(eventName, args.eventType)
    if not eventConfig then
        return
    end

    local title = parseMessageTemplate(eventConfig.title, args)
    local message = parseMessageTemplate(eventConfig.description, args)
    local color = eventConfig.color or config.defaultColor
    local channel = eventConfig.channel

    local jsonData = getJSONData() or {}
    if not jsonData[config.serverID] then
        return
    end

    jsonData[config.serverID].status = serverData.status
    _insert(jsonData[config.serverID].sapp_events, {
        title = title,
        description = message,
        color = color,
        channel = channel
    })

    updateJSONData(jsonData)
end

--- Retrieves a tag address based on the provided type and name.
-- @param Type String The type of the tag
-- @param Name String The name of the tag
-- @return number|nil The tag value if found, otherwise nil
local function getTag(type, name)
    local Tag = lookup_tag(type, name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

--- Called when a new game starts, initializes various variables, adds players to a list, and sends an "OnStart" event notification.
-- @param OnScriptLoad Boolean Indicates whether the script is being loaded for the first time
-- @return nil
function OnStart(OnScriptLoad)

    -- Get the current game type
    game_type = get_var(0, "$gt")
    if game_type == 'n/a' then
        return
    end

    -- Initialize variables
    players, first_blood, ffa = {}, true, (get_var(0, '$ffa') == '1')
    falling, distance = getTag('jpt!', 'globals\\falling'), getTag('jpt!', 'globals\\distance')
    map, mode = get_var(0, "$map"), get_var(0, "$mode")

    -- Add all present players to the list
    for i = 1, 16 do
        if player_present(i) then
            OnJoin(i, OnScriptLoad)
        end
    end

    -- Update server status fields
    local serverName, totalPlayers, playerList = getServerName(), getTotalPlayers(), getPlayerList()
    serverData.status.fields[1].value = "- **" .. serverName .. "**"
    serverData.status.fields[3].value = "- **" .. map .. "**"
    serverData.status.fields[4].value = "- **" .. mode .. "** | " .. (ffa and "*FFA*" or "*Team Play*") .. ""
    serverData.status.fields[5].value = "- **" .. totalPlayers .. "**"
    serverData.status.fields[6].value = playerList

    -- Send an "OnStart" event notification
    notify("OnStart", {
        ["$map"] = map,
        ["$mode"] = mode,
        ["$faa"] = (ffa and "FFA" or "Team Play")
    })
end

--- Called when the game ends, updates server status information, and sends an "OnEnd" event notification.
-- @return nil
function OnEnd()

    serverData.status.fields[3].value = "*Loading new Map...*"
    serverData.status.fields[4].value = "N/A"

    notify("OnEnd", {
        ["$totalPlayers"] = getTotalPlayers(),
        ["$map"] = map,
        ["$mode"] = mode,
        ["$faa"] = (ffa and "FFA" or "Team Play")
    })
end

--- Retrieves player information to be used when handling join or quit events.
-- @param player Table A table representing the player
-- @param isQuit Boolean Indicates whether it's a quit event
-- @return Table A table containing various player details
local function getJoinQuit(player, isQuit)

    local ping = get_var(player.id, "$ping")
    local timeStamp = _date(config.timeStampFormat)
    local level = _tonumber(get_var(player.id, '$lvl'))

    player.level = level -- update their level in case it was changed during the game

    local totalPlayers = getTotalPlayers(isQuit)
    local playerList = getPlayerList(isQuit, player.id)

    serverData.status.fields[5].value = "- **" .. totalPlayers .. "**"
    serverData.status.fields[6].value = playerList

    return {
        ["$playerID"] = player.id,
        ["$playerName"] = player.name,
        ["$ipAddress"] = player.ip,
        ["$cdHash"] = player.hash,
        ["$indexID"] = player.id,
        ["$privilegeLevel"] = player.level,
        ["$joinTime"] = timeStamp,
        ["$ping"] = ping,
        ["$totalPlayers"] = totalPlayers
    }
end

--- Called when a player joins the game, updates the total players count, and sends an "OnJoin" event notification.
-- @param id number The player's index ID
-- @param OnScriptLoad Boolean Indicates whether the script is being loaded for the first time (script may be loaded during a game)
-- @return nil
function OnJoin(id, OnScriptLoad)

    players[id] = {
        id = id,
        meta = 0,
        switched = false,
        ip = get_var(id, '$ip'),
        name = get_var(id, '$name'),
        team = get_var(id, '$team'),
        hash = get_var(id, '$hash')
    }

    if not OnScriptLoad then
        notify("OnJoin", getJoinQuit(players[id], false))
    end
end

--- Called when a player spawns in the game, resets player meta data, and sends an "OnSpawn" event notification.
-- @param id number The player's index ID
-- @return nil
function OnSpawn(id)
    local player = players[id]
    if player then

        player.meta = 0
        player.switched = nil
        player.lapTime = _clock()

        notify("OnSpawn", {
            ["$playerName"] = player.name,
            ["$playerID"] = player.id
        })
    end
end

--- Called when a player quits the game, updates the total players count, and sends an "OnQuit" event notification.
-- @param id number The player's index ID
-- @return nil
function OnQuit(id)
    local player = players[id]
    if player then
        notify("OnQuit", getJoinQuit(player, true))
    end
    players[id] = nil -- remove the player from the list
end

--- Called when a player switches teams, updates player data, and sends an "OnSwitch" event notification.
-- @param id number The player's index ID
-- @return nil
function OnSwitch(id)
    local player = players[id]
    if player then

        player.team = get_var(id, '$team')
        player.switched = true

        notify("OnSwitch", {
            ["$playerName"] = player.name,
            ["$team"] = player.team,
            ["$playerID"] = player.id
        })
    end
end

--- Called when a player warps, sends an "OnWarp" event notification.
-- @param id number The player's index ID
-- @return nil
function OnWarp(id)
    local player = players[id]
    if player then
        notify("OnWarp", {
            ["$playerName"] = player.name,
            ["$playerID"] = player.id
        })
    end
end

--- Called when the game is reset, sends an "OnReset" event notification with the current map and mode information.
-- @return nil
function OnReset()
    notify("OnReset", {
        ["$map"] = get_var(0, "$map"),
        ["$mode"] = get_var(0, "$mode")
    })
end

--- Called when a player logs in, sends an "OnLogin" event notification with the player's name.
-- @param id number The player's index ID
-- @return nil
function OnLogin(id)
    local player = players[id]
    if player then
        notify("OnLogin", {
            ["$playerName"] = player.name,
            ["$playerID"] = player.id
        })
    end
end

--- Called when a player is snapped, sends an "OnSnap" event notification with the player's name.
-- @param id number The player's index ID
-- @return nil
function OnSnap(id)
    local player = players[id]
    if player then
        notify("OnSnap", {
            ["$playerName"] = player.name,
            ["$playerID"] = player.id
        })
    end
end

--- A table containing descriptions for different command types.
-- @table command_type
-- @field [1] string "rcon command"
-- @field [2] string "console command"
-- @field [3] string "chat command"
-- @field [4] string "unknown command type"
local command_type = {
    [0] = "RCON",
    [1] = "CONSOLE",
    [2] = "CHAT",
    [3] = "UNKNOWN"
}

--- Called when a command is executed, sends an "OnCommand" event notification with command details.
-- @param id number The player's index ID
-- @param command string The executed command
-- @param environment number The command type
-- @return nil
function OnCommand(id, command, environment)
    local player = players[id]
    if player and id > 0 then

        local cmd = command:match("^(%S+)")

        notify("OnCommand", {
            ["$type"] = command_type[environment],
            ["$playerName"] = player.name,
            ["$id"] = id,
            ["$command"] = cmd,
            ["$playerID"] = player.id
        })
    end
end

--- A table containing descriptions for different chat types.
-- @table chat_type
-- @field [1] string "GLOBAL"
-- @field [2] string "TEAM"
-- @field [3] string "VEHICLE"
-- @field [4] string "UNKNOWN"
local chat_type = {
    [0] = "GLOBAL",
    [1] = "TEAM",
    [2] = "VEHICLE",
    [3] = "UNKNOWN"
}

--- Checks if the provided string is a command by checking if the first character is a forward slash or a backslash.
-- @param str string The string to check for command
-- @return boolean True if the string is a command, false otherwise
local function isCommand(str)
    return (str:sub(1, 1) == "/" or str:sub(1, 1) == "\\")
end

--- Called when a chat message is sent, checks if the message is a command, and sends an "OnChat" event notification if it is not a command.
-- @param id number The player's index ID
-- @param message string The chat message
-- @param environment number The chat type
-- @return nil
function OnChat(id, message, environment)
    local player = players[id]
    if player and id > 0 then

        local msg = message:match("^(%S+)")
        if not isCommand(msg) then

            notify("OnChat", {
                ["$type"] = chat_type[environment],
                ["$playerName"] = player.name,
                ["$id"] = id,
                ["$message"] = message,
                ["$playerID"] = player.id
            })
        end
    end
end

--- Formats the lap time in minutes, seconds, and milliseconds.
-- @param lapTime number The lap time in seconds
-- @return string The formatted lap time
local function formatTime(lapTime)
    local minutes = _floor(lapTime / 60)
    local seconds = _floor(lapTime % 60)
    local milliseconds = _floor((lapTime * 1000) % 1000)
    return _format("%02d:%02d.%03d", minutes, seconds, milliseconds)
end

--- Called when a player scores, sends an "OnScore" event notification with details about the score.
-- @param id number The player's index ID
function OnScore(id)

    local player = players[id]
    if player then

        local eventType = ({
            ctf = 1,
            race = not ffa and 2 or 3,
            slayer = not ffa and 4 or 5
        })[game_type]

        if game_type == "race" then
            player.lapTime = formatTime(_clock() - player.lapTime)
        end

        local blue_score = get_var(0, "$bluescore")
        local red_score = get_var(0, "$redscore")

        notify("OnScore", {
            ["eventType"] = eventType,
            ["$lapTime"] = player.lapTime or "N/A",
            ["$totalTeamLaps"] = player.team == "red" and red_score or blue_score,
            ["$playerScore"] = get_var(id, "$score"),
            ["$playerName"] = player.name,
            ["$playerTeam"] = player.team or "FFA",
            ["$redScore"] = red_score,
            ["$blueScore"] = blue_score,
        })

        player.lapTime = _clock()
    end
end

--- Called when a player dies, sends an "OnDeath" event notification with details about the death.
-- @param victimIndex number The victim's index ID
-- @param killerIndex number The killer's index ID (0 for world kills, -1 for server kills)
-- @param metaID number The player's meta ID
-- @return nil
function OnDeath(victim, killer, metaID)

    victim = _tonumber(victim)
    killer = _tonumber(killer)

    local victimPlayer = players[victim]
    local killerPlayer = players[killer]

    if victimPlayer then

        -- Set the victim's meta ID if provided (triggered by EVENT_DAMAGE_APPLICATION)
        if metaID then
            victimPlayer.meta = metaID
            return true
        end

        local squashed = (killer == 0)
        local guardians = (killer == nil)
        local suicide = (killer == victim)
        local pvp = (killer > 0 and killer ~= victim)
        local server = (killer == -1 and not victimPlayer.switched)
        local fell = (victimPlayer.meta == falling or victimPlayer.meta == distance)
        local betrayal = (killerPlayer and not ffa and victimPlayer.team == killerPlayer.team and killer ~= victim)

        local eventType

        if pvp and not betrayal then

            if first_blood then
                first_blood = false
                eventType = 1
                goto done
            elseif not player_alive(killer) then
                eventType = 2
                goto done
            end

            local dyn = get_dynamic_player(killer)
            if dyn ~= 0 then
                local vehicle = read_dword(dyn + 0x11C)
                if vehicle ~= 0xFFFFFFFF then
                    eventType = 3
                    goto done
                end
            end

            eventType = 4

        elseif guardians then
            eventType = 5
        elseif suicide then
            eventType = 6
        elseif betrayal then
            eventType = 7
        elseif squashed then
            eventType = 8
        elseif fell then
            eventType = 9
        elseif server then
            eventType = 10
        else
            eventType = 11
        end

        :: done ::

        serverData.status.fields[6].value = getPlayerList()

        notify("OnDeath", {
            ["eventType"] = eventType,
            ["$killerName"] = killerPlayer and killerPlayer.name or "N/A",
            ["$victimName"] = victimPlayer and victimPlayer.name or "N/A",
            ["$killerID"] = killerPlayer and killerPlayer.id or "N/A",
            ["$victimID"] = victimPlayer and victimPlayer.id or "N/A",
        })
    end
end

function OnScriptUnload()
    -- N/A
end