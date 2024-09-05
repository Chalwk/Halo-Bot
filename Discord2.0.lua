--[[
/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

Script Name: Discord, for SAPP (PC & CE)

Description:
This script sends customizable sapp event notifications to the Halo Discord Bot, which then displays them in a designated Discord channel.
Users can configure the script to send notifications for various events such as player joins, leaves, deaths, commands, chat messages, etc.
All event notifications are sent as customizable embed messages, allowing users to edit the title, description, color, and designated channel according to their preferences.

Events:

  EVENT:                    TRIGGERED WHEN:
- event_chat                A player sends a chat message
- event_command             A player executes a command
- event_game_start          A new game starts
- event_game_end            A game ends
- event_prejoin             A player attempts to join the server
- event_join                A player joins the server
- event_leave               A player leaves the server
- event_die                 A player dies
- event_snap                A player snaps
- event_spawn               A player spawns
- event_login               A player logs in
- event_team_switch         A player switches teams
- script_load               This script is loaded
- script_unload             This script is unloaded
- event_map_reset           The map is reset
]]--

local config = {

    -- General settings:

    -- The server ID (unique identifier)
    -- This is used to store data for multiple servers in a single JSON file.
    -- Make sure to change this value (ane keep them unique) if you are running multiple servers.
    serverID = "server_1",

    -- Default embed message color
    defaultColor = "GREEN",

    -- The timestamp format
    timeStampFormat = "%A %d %B %Y - %X",

    -- Path to the JSON Data file that will store all the events to be processed by the Discord Bot.
    jsonEventsPath = "./Halo-Bot/halo-events.json",

    -- Path to the JSON library file
    jsonLibraryPath = "./Halo-Bot/json.lua",

    -- Status settings
    STATUS_SETTINGS = {
        -- The channel ID where the bot will update an embed status message (e.g., server name, IP, map, mode, total players)
        channelID = "1280825407255347200",
        -- The server name
        serverName = "LNZ DEV SERVER",
        -- The server IP
        serverIP = "127.0.0.1:2310"
    },

    --------------------------------
    -- End of general settings --
    --------------------------------

    -- Event-specific settings:
    events = {
        ["OnStart"] = {
            -- Available placeholders: $map, $mode, $totalPlayers, $faa
            enabled = true,
            title = "🌄 A new game has started!",
            description = "Map: [$map] - [$mode] - ($faa) | Players: $totalPlayers",
            color = "GREEN",
            channel = "1280825450901405757"
        },
        ["OnEnd"] = {
            -- Available placeholders: $map, $mode, $totalPlayers, $faa
            enabled = true,
            title = "🌅 The game has ended!",
            description = "The game ended with $totalPlayers players.",
            color = "RED",
            channel = "1280825450901405757"
        },
        ["OnJoin"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers
            enabled = true,
            title = "🟢 Player has joined the server!",
            description = "Player: $playerName",
            color = "GREEN",
            channel = "1280825450901405757"
        },
        -- OnQuit:
        ["OnQuit"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers
            enabled = true,
            title = "🔴 Player has left the server!",
            description = "Player: $playerName",
            color = "RED",
            channel = "1280825450901405757"
        },
        ["OnSpawn"] = {
            -- Available placeholders: $playerName
            enabled = false,
            title = "🐣 Player has spawned!",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "1280825450901405757"
        },
        -- OnSwitch:
        ["OnSwitch"] = {
            -- Available placeholders: $playerName, $team
            enabled = true,
            title = "👥 Player has switched teams!",
            description = "Player: $playerName switched teams. New team: [$team]",
            color = "YELLOW",
            channel = "1280825450901405757"
        },
        -- OnWarp:
        ["OnWarp"] = {
            -- Available placeholders: $playerName
            enabled = true,
            title = "𒅒 Player is warping...",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "1280825450901405757"
        },
        ["OnReset"] = {
            -- Available placeholders: $map, $mode
            enabled = true,
            title = "🔄 The map has been reset!",
            description = "Map: [$map / $mode]",
            color = "YELLOW",
            channel = "1280825450901405757"
        },
        ["OnLogin"] = {
            -- Available placeholders: $playerName
            enabled = false,
            title = "👤 Player has logged in!",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "1280825450901405757"
        },
        ["OnSnap"] = {
            -- Available placeholders: $playerName
            enabled = false,
            title = "⊹ Player has snapped!",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "1280825450901405757"
        },
        ["OnCommand"] = {
            -- Available placeholders: $type, $name, $id, $cmd
            enabled = false,
            title = "⌘ Command executed!",
            description = "[$type] $name ($id): $cmd",
            color = "RED",
            channel = "1280825450901405757"
        },
        ["OnChat"] = {
            -- Available placeholders: $type, $name, $id, $msg
            enabled = true,
            title = "🗨️ Chat message sent!",
            description = "[$type] $name ($id): $msg",
            color = "BLUE",
            channel = "1280825450901405757"
        },
        ["OnDeath"] = {
            [1] = {
                -- first blood
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ First blood!",
                description = "$killerName drew first blood",
                color = "RED",
                channel = "1280825450901405757"
            },
            [2] = {
                -- killed from the grave
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Killed from the grave!",
                description = "$victimName was killed from the grave by $killerName",
                color = "RED",
                channel = "1280825450901405757"
            },
            [3] = {
                -- vehicle kill
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Vehicle kill!",
                description = "$victimName was run over by $killerName",
                color = "RED",
                channel = "1280825450901405757"
            },
            [4] = {
                -- pvp
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ PvP kill!",
                description = "$victimName was killed by $killerName",
                color = "RED",
                channel = "1280825450901405757"
            },
            [5] = {
                -- guardians
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Guardians kill!",
                description = "$victimName was killed by the guardians",
                color = "RED",
                channel = "1280825450901405757"
            },
            [6] = {
                -- suicide
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Suicide!",
                description = "$victimName committed suicide",
                color = "RED",
                channel = "1280825450901405757"
            },
            [7] = {
                -- betrayal
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Betrayal!",
                description = "$victimName was betrayed by $killerName",
                color = "RED",
                channel = "1280825450901405757"
            },
            [8] = {
                -- squashed by a vehicle
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Squashed by a vehicle!",
                description = "$victimName was squashed by a vehicle",
                color = "RED",
                channel = "1280825450901405757"
            },
            [9] = {
                -- fall damage
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Fall Damage!",
                description = "$victimName fell and broke their leg",
                color = "RED",
                channel = "1280825450901405757"
            },
            [10] = {
                -- killed by the server
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Kill by the server!",
                description = "$victimName was killed by the server",
                color = "RED",
                channel = "1280825450901405757"
            },
            [11] = {
                -- unknown death
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Unknown death!",
                description = "$victimName died",
                color = "RED",
                channel = "1280825450901405757"
            }
        }
    }
}

api_version = '1.12.0.0'

-- Configuration ends here -----------------------------------------------------------------------
-- Do not edit below this line

local serverData, players = {}, {}

local date = os.date
local json = loadfile(config.jsonLibraryPath)()

local ffa, falling, distance, first_blood, map, mode

--- Reads the JSON data file and returns the decoded data as a Lua table.
-- @return Table|nil Decoded JSON data or nil if the file couldn't be read
local function getJSONData()
    local file = io.open(config.jsonEventsPath, "r")
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
    local file = io.open(config.jsonEventsPath, "w")
    if file then
        file:write(json:encode_pretty(t))
        file:close()
    end
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

    -- Configure server status settings
    local status = config.STATUS_SETTINGS

    -- Initialize serverData and status
    serverData = {
        sapp_events = {},
        status = {
            ["CHANNEL_ID"] = status["channelID"],
            ["Server Name"] = status["serverName"],
            ["Server IP"] = status["serverIP"],
            ["Map"] = "N/A",
            ["Mode"] = "N/A",
            ["Total Players"] = "N/A",
            ["Player List"] = {}
        }
    }

    -- Initialize or read the existing JSON data file, add serverData, and update the JSON file
    local jsonData = getJSONData() or {}
    jsonData[config.serverID] = serverData
    updateJSONData(jsonData)

    -- Trigger OnStart with a new game event
    OnStart(true)
end

--- Calculates the total number of players on the server, taking into account whether a player has quit or not.
-- @param isQuit Boolean Indicates if a player has quit
-- @return number Total number of players
local function getTotalPlayers(isQuit)

    -- Retrieve the current number of players on the server and adjust total players count if a player has quit.
    local total = tonumber(get_var(0, "$pn"))
    return (isQuit and total - 1 or total)
end

--- Parses a message template and replaces placeholders with corresponding values from the given arguments.
-- @param String String The message template containing placeholders
-- @param args Table A key-value table with placeholders and values
-- @return String The parsed message with placeholders replaced by their corresponding values
local function parseMessageTemplate(String, args)

    -- Iterate over the provided arguments and replace placeholders in the message template
    local message = String

    for placeholder, value in pairs(args) do
        message = message:gsub(placeholder, value)
    end

    return message
end

--- Adds a new event notification to the "halo-events.json" database, which will be processed by the Java Bot.
-- @param eventName String The name of the event
-- @param args Table The arguments for the event, used to parse message templates
-- @return nil
local function notify(eventName, args)

    -- Retrieve the event configuration based on the provided event name
    local eventConfig = config.events[eventName]
    if (not eventConfig.enabled) then
        return
    end

    -- Retrieve the title, description, color, and channel for the event
    local title = eventConfig.title
    local description = eventConfig.description
    local color = eventConfig.color or config.defaultColor
    local channel = eventConfig.channel

    -- Check if the event is an "OnDeath" event and update the embed details accordingly
    local embedTitle, embedDescription, embedColor, embedChannel
    if eventName == "OnDeath" then
        local deathEvent = config.events["OnDeath"][args.eventType]
        if deathEvent and deathEvent.enabled then
            embedTitle = deathEvent.title
            embedDescription = deathEvent.description
            embedColor = deathEvent.color or config.defaultColor
            embedChannel = deathEvent.channel
            goto next
        end
    end

    -- Set the embed details based on the event configuration
    embedTitle = title
    embedDescription = description
    embedColor = color
    embedChannel = channel

    :: next ::

    -- Parse the message template with the provided arguments
    local message = parseMessageTemplate(embedDescription, args)
    embedTitle = parseMessageTemplate(embedTitle, args)

    -- Update the serverData with the new event notification
    local jsonData = getJSONData()
    table.insert(serverData.sapp_events, {
        title = embedTitle,
        description = message,
        color = embedColor,
        channel = embedChannel
    })

    -- Update the JSON data file with the new event notification
    jsonData[config.serverID] = serverData
    updateJSONData(jsonData)
end

--- Retrieves a tag value based on the provided type and name.
-- @param Type String The type of the tag
-- @param Name String The name of the tag
-- @return number|nil The tag value if found, otherwise nil
local function getTag(Type, Name)

    -- Look up the tag based on the provided type and name
    local Tag = lookup_tag(Type, Name)

    -- Check if a valid tag was found, and if so, return the corresponding value
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

--- Retrieves a list of players currently on the server.
-- @return Table A table containing the names of all players on the server
local function getPlayerList(excludeThisPlayer)
    local playerList = {}
    for i = 1, 16 do
        if player_present(i) then
            local player = players[i]
            if player and i ~= excludeThisPlayer then
                table.insert(playerList, player.name)
            end
        end
    end
    return playerList
end

--- Called when a new game starts, initializes various variables, adds players to a list, and sends an "OnStart" event notification.
-- @param OnScriptLoad Boolean Indicates whether the script is being loaded for the first time
-- @return nil
function OnStart(OnScriptLoad)

    -- Ensure game type is not 'n/a' before proceeding
    if get_var(0, '$gt') == 'n/a' then
        return
    end

    -- Initialize variables
    players = {}
    first_blood = true
    -- Set ffa variable based on the '$ffa' var value
    ffa = (get_var(0, '$ffa') == '1')

    -- Get tag values for 'globals\\falling' and 'globals\\distance'
    falling = getTag('jpt!', 'globals\\falling')
    distance = getTag('jpt!', 'globals\\distance')

    -- Retrieve the current map and mode from game vars
    map = get_var(0, "$map")
    mode = get_var(0, "$mode")

    -- Loop through player slots, add joined players to the list, and call OnJoin function
    for i = 1, 16 do
        if player_present(i) then
            OnJoin(i, OnScriptLoad)
        end
    end

    local totalPlayers = getTotalPlayers()

    -- Update serverData with status information
    serverData.status["Map"] = map
    serverData.status["Mode"] = mode
    serverData.status["Total Players"] = totalPlayers
    serverData.status["Player List"] = getPlayerList()

    -- Send an "OnStart" event notification with relevant game information
    notify("OnStart", {
        ["$totalPlayers"] = totalPlayers,
        ["$map"] = map,
        ["$mode"] = mode,
        ["$faa"] = (ffa and "FFA" or "Team Play")
    })
end

--- Called when the game ends, updates server status information, and sends an "OnEnd" event notification.
-- @return nil
function OnEnd()

    -- Update serverData with new status information
    serverData.status["Map"] = "Loading new Map..."
    serverData.status["Mode"] = "N/A"

    -- Send an "OnEnd" event notification with relevant game information
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
    local timeStamp = date(config.timeStampFormat)
    local level = tonumber(get_var(player.id, '$lvl'))

    player.level = level -- update their level in case it was changed during the game

    local totalPlayers = getTotalPlayers(isQuit)
    serverData.status["Total Players"] = totalPlayers
    serverData.status["Player List"] = getPlayerList(player.id) -- exclude the player who quit (if it's a quit event)

    -- Return a table containing player information
    return {
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
-- @param OnScriptLoad Boolean Indicates whether the script is being loaded for the first time
-- @return nil
function OnJoin(id, OnScriptLoad)

    -- Initialize player object for this player
    players[id] = {
        id = id,
        meta = 0,
        switched = false,
        ip = get_var(id, '$ip'),
        name = get_var(id, '$name'),
        team = get_var(id, '$team'),
        hash = get_var(id, '$hash')
    }

    -- Retrieve the player object and check if it's not the script's first load
    local player = players[id]
    if (player and not OnScriptLoad) then

        -- Update the total players count and send an "OnJoin" event notification
        notify("OnJoin", getJoinQuit(player))
    end
end

--- Called when a player spawns in the game, resets player meta data, and sends an "OnSpawn" event notification.
-- @param id number The player's index ID
-- @return nil
function OnSpawn(id)

    -- Retrieve the player object
    local player = players[id]
    if player then

        -- Reset player meta data and send an "OnSpawn" event notification
        players[id].meta = 0
        players[id].switched = nil
        notify("OnSpawn", {
            ["$playerName"] = player.name
        })
    end
end

--- Called when a player quits the game, updates the total players count, and sends an "OnQuit" event notification.
-- @param id number The player's index ID
-- @return nil
function OnQuit(id)

    -- Retrieve the player object and send an "OnQuit" event notification
    local player = players[id]
    if (player) then

        -- Update the total players count and send an "OnQuit" event notification
        notify("OnQuit", getJoinQuit(player, true))
    end

    -- Remove the player from the players table
    players[id] = nil
end

--- Called when a player switches teams, updates player data, and sends an "OnSwitch" event notification.
-- @param id number The player's index ID
-- @return nil
function OnSwitch(id)

    -- Retrieve the player object and update their team
    local player = players[id]
    if player then

        -- Update the player's team and set the switched flag to true
        player.team = get_var(id, '$team')
        player.switched = true

        -- Send an "OnSwitch" event notification
        notify("OnSwitch", {
            ["$playerName"] = player.name,
            ["$team"] = player.team
        })
    end
end

--- Called when a player warps, sends an "OnWarp" event notification.
-- @param id number The player's index ID
-- @return nil
function OnWarp(id)

    -- Retrieve the player object and send an "OnWarp" event notification
    local player = players[id]
    if player then

        -- Send an "OnWarp" event notification
        notify("OnWarp", {
            ["$playerName"] = player.name
        })
    end
end

--- Called when the game is reset, sends an "OnReset" event notification with the current map and mode information.
-- @return nil
function OnReset()
    -- Send an "OnReset" event notification
    notify("OnReset", {
        ["$map"] = get_var(0, "$map"),
        ["$mode"] = get_var(0, "$mode")
    })
end

--- Called when a player logs in, sends an "OnLogin" event notification with the player's name.
-- @param id number The player's index ID
-- @return nil
function OnLogin(id)

    -- Retrieve the player object and send an "OnLogin" event notification
    local player = players[id]
    if (player) then

        -- Send an "OnLogin" event notification
        notify("OnLogin", {
            ["$playerName"] = player.name
        })
    end
end

--- Called when a player is snapped, sends an "OnSnap" event notification with the player's name.
-- @param id number The player's index ID
-- @return nil
function OnSnap(id)

    -- Retrieve the player object and send an "OnSnap" event notification
    local player = players[id]
    if (player) then

        -- Send an "OnSnap" event notification
        notify("OnSnap", {
            ["$playerName"] = player.name
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
    [0] = "rcon command",
    [1] = "console command",
    [2] = "chat command",
    [3] = "unknown command type"
}

--- Called when a command is executed, sends an "OnCommand" event notification with command details.
-- @param id number The player's index ID
-- @param command string The executed command
-- @param environment number The command type
-- @return nil
function OnCommand(id, command, environment)

    -- Retrieve the player object and validate its existence
    local player = players[id]

    if (player and id > 0) then

        -- Retrieve the command name
        local cmd = command:match("^(%S+)")

        -- Send an "OnCommand" event notification
        notify("OnCommand", {
            ["$type"] = command_type[environment],
            ["$name"] = player.name,
            ["$id"] = id,
            ["$cmd"] = cmd
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

    -- Retrieve the player object and validate its existence
    local player = players[id]

    if (player and id > 0) then

        -- Check if the message is a command
        local msg = message:match("^(%S+)")

        if (not isCommand(msg)) then

            -- Send an "OnChat" event notification
            notify("OnChat", {
                ["$type"] = chat_type[environment],
                ["$name"] = player.name,
                ["$id"] = id,
                ["$msg"] = message
            })
        end
    end
end

--- Called when a player dies, sends an "OnDeath" event notification with details about the death.
-- @param victimIndex number The victim's index ID
-- @param killerIndex number The killer's index ID (0 for world kills, -1 for server kills)
-- @param metaID number The player's meta ID
-- @return nil
function OnDeath(victimIndex, killerIndex, metaID)

    -- Convert the index IDs to numbers
    victimIndex = tonumber(victimIndex)
    killerIndex = tonumber(killerIndex)

    -- Retrieve the victim and killer player objects
    local victimPlayer = players[victimIndex]
    local killerPlayer = players[killerIndex]

    -- Validate the existence of the victim player and set their meta ID if provided
    if victimPlayer then

        -- Set the victim's meta ID if provided (triggered by EVENT_DAMAGE_APPLICATION)
        if metaID then
            victimPlayer.meta = metaID
            return true
        end

        -- Determine the death type based on the killer's index
        local squashed = (killerIndex == 0)
        local guardians = (killerIndex == nil)
        local suicide = (killerIndex == victimIndex)
        local pvp = (killerIndex > 0 and killerIndex ~= victimIndex)
        local server = (killerIndex == -1 and not victimPlayer.switched)
        local fell = (victimPlayer.meta == falling or victimPlayer.meta == distance)
        local betrayal = (killerPlayer and not ffa and victimPlayer.team == killerPlayer.team and killerIndex ~= victimIndex)

        local eventType

        -- PvP death
        if pvp and not betrayal then

            -- Check for first blood
            if first_blood then
                first_blood = false
                eventType = 1
                goto done
            end

            -- Check for killed from the grave
            if not player_alive(killerIndex) then
                eventType = 2
                goto done
            end

            -- Check for vehicle kill
            local dyn = get_dynamic_player(killerIndex)
            if dyn ~= 0 then
                local vehicle = read_dword(dyn + 0x11C)
                if vehicle ~= 0xFFFFFFFF then
                    eventType = 3
                    goto done
                end
            end

            -- pvp
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

        -- Send an "OnDeath" event notification
        notify("OnDeath", {
            ["eventType"] = eventType,
            ["$killerName"] = killerPlayer and killerPlayer.name or "",
            ["$victimName"] = victimPlayer.name
        })
    end
end

function OnScriptUnload()
    -- N/A
end