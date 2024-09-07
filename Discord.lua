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

    -- Unique identifier for the server
    -- Used to store data for multiple servers in a single JSON file.
    -- Must be changed and kept unique if you are running multiple servers.
    serverID = "server_1",

    -- Default color for embed messages
    -- Available colors: "GREEN", "BLUE", "RED", "YELLOW", etc.
    defaultColor = "GREEN",

    -- Format for displaying timestamps in messages
    -- Formatting options are similar to the C library function `strftime()`
    timeStampFormat = "%A %d %B %Y - %X",

    -- Status settings:
    -- These settings control how the bot updates the server status message in Discord.
    STATUS_SETTINGS = {
        -- The channel ID where the bot will update the server status message.
        -- This message includes details such as server name, IP, map, mode, and total players.
        channelID = "xxxxxxxxxxxxxxxxxxxxxxxx",

        -- The interval (in seconds) at which the bot will update the server status message.
        -- Set to 0 to disable automatic status updates.
        statusCheckInterval = 30,

        -- The name of the server to be displayed in the status message.
        serverName = "YOUR_SERVER_NAME_HERE",

        -- The IP address and port of the server to be displayed in the status message.
        serverIP = "xxx.xxx.xxx.xxx:xxxx"

        -- At the moment, other data is included in the status message by default and cannot be customized (e.g., map, mode, total players).
        -- This will change in future updates.
    },

    --------------------------------
    -- End of general settings --
    --------------------------------

    -- Interval (in seconds) at which the bot will check for new Halo events.
    -- Set to 0 to disable automatic event notifications.
    eventCheckInterval = 1,

    -- Available colors for embed messages:
    -- RED, BLUE, GREEN, YELLOW, ORANGE, CYAN, MAGENTA, PINK, WHITE, BLACK, GRAY, DARK_GRAY, LIGHT_GRAY

    -- Embed format:
    -- enabled (boolean): Whether the event notification is enabled
    -- title (string): The title of the embed message
    -- description (string): The description of the embed message
    -- color (string): The color of the embed message
    -- channel (string): The channel ID where the embed message will be sent

    -- Event-specific settings:
    events = {
        ["OnStart"] = {
            -- Available placeholders: $map, $mode, $totalPlayers, $faa
            enabled = true,
            title = "🌄 A new game has started!",
            description = "- Map: [**$map**]\n- [**$mode**] (**$faa**)\n- Players: **$totalPlayers**",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnEnd"] = {
            -- Available placeholders: $map, $mode, $totalPlayers, $faa
            enabled = true,
            title = "🌅 The game has ended!",
            description = "The game ended with **$totalPlayers** players.",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnJoin"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers, $playerID
            enabled = true,
            title = "🟢 $playerName has joined the server!",
            description = "",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- OnQuit:
        ["OnQuit"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers, $playerID
            enabled = true,
            title = "🔴 $playerName has left the server!",
            description = "",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnSpawn"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = false,
            title = "🐣 $playerName has spawned!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- OnSwitch:
        ["OnSwitch"] = {
            -- Available placeholders: $playerName, $team, $playerID
            enabled = true,
            title = "👥 Player has switched teams!",
            description = "**$playerName** switched teams. New team: **[$team]**",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- OnWarp:
        ["OnWarp"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = true,
            title = "𒅒 $playerName is warping...",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnReset"] = {
            -- Available placeholders: $map, $mode
            enabled = true,
            title = "🔄 The map has been reset!",
            description = "- **$map**\n- **$mode**",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnLogin"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = false,
            title = "👤 $playerName has logged in!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnSnap"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = false,
            title = "⊹ $playerName snapped!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnCommand"] = {
            -- Available placeholders: $type, $name, $id, $command, $playerID
            enabled = false,
            title = "⌘ Command executed!",
            description = "[**$type**] **$playerName** (**$id**): *$command*",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnChat"] = {
            -- Available placeholders: $type, $playerName, $id, $message, $playerID
            enabled = true,
            title = "🗨️ Chat message sent!",
            description = "[**$type**] **$playerName** (**$id**): *$message*",
            color = "BLUE",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnScore"] = {
            [1] = {
                -- Available placeholders: $playerName, $playerTeam, $redScore, $blueScore
                enabled = true,
                title = "🏆 CTF Scoreboard updated!",
                description = "$playerName captured the flag for the **$playerTeam team**\n- Red Team Score: **$redScore**\n- Blue Team Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $playerTeam, $lapTime, $totalTeamLaps
            [2] = {
                enabled = true,
                title = "🏆 Team RACE Scoreboard updated!",
                description = "$playerName completed a lap for the $playerTeam\n- Lap Time: **$lapTime**\n- Total Laps: **$totalTeamLaps**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $lapTime, $playerScore
            [3] = {
                enabled = true,
                title = "🏆 FFA RACE Scoreboard updated!",
                description = "$playerName completed a lap\n- Lap Time: **$lapTime**\n- Total Laps: **$playerScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $playerTeam, $redScore, $blueScore
            [4] = {
                enabled = true,
                title = "🏆 Team Slayer Scoreboard updated!",
                description = "$playerName scored for the **$playerTeam team**\n- Red Team Score: **$redScore**\n- Blue Team Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $redScore, $blueScore
            [5] = {
                enabled = true,
                title = "🏆 FFA Slayer Scoreboard updated!",
                description = "$playerName scored\n- Red Team Score: **$redScore**\n- Blue Team Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            }
        },
        ["OnDeath"] = {
            -- Available placeholders: $killerName, $victimName, $killerID, $victimID
            [1] = {
                -- first blood
                enabled = true,
                title = "☠️ $killerName drew first blood!",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [2] = {
                -- killed from the grave
                enabled = true,
                title = "☠️ $victimName was killed from the grave by $killerName",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [3] = {
                -- vehicle kill (includes being run over or killed by the vehicle's weapon)
                -- In order to preserve support for custom maps that have custom vehicle tag ids, the script will not check for the vehicle tag id.
                -- Instead we send a generic message for all vehicle kills.
                enabled = true,
                title = "☠️ $victimName was killed by $killerName",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [4] = {
                -- pvp
                enabled = true,
                title = "☠️ $victimName was killed by $killerName",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [5] = {
                -- guardians
                enabled = true,
                title = "☠️ $victimName was killed by the guardians",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [6] = {
                -- suicide
                enabled = true,
                title = "☠️ $victimName committed suicide!",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [7] = {
                -- betrayal
                enabled = true,
                title = "☠️ $victimName was betrayed by $killerName!",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [8] = {
                -- squashed by a vehicle (when an unoccupied vehicle collides with you)
                enabled = true,
                title = "☠️ $victimName was squashed by a vehicle",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [9] = {
                -- fall damage
                enabled = true,
                title = "☠️ $victimName fell and broke their leg",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [10] = {
                -- killed by the server
                enabled = true,
                title = "☠️ $victimName was killed by the server",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [11] = {
                -- unknown death
                enabled = true,
                title = "☠️ $victimName died",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxx"
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
local _floor = math.floor
local _format = string.format
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

    -- Configure server status settings
    local status = config.STATUS_SETTINGS

    -- Initialize serverData and status
    serverData = {
        sapp_events = {},
        eventCheckInterval = config.eventCheckInterval,
        statusCheckInterval = status.statusCheckInterval,
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
    local total = _tonumber(get_var(0, "$pn"))
    return (isQuit and total - 1 or total)
end

--- Parses a message template and replaces placeholders with corresponding values from the given arguments.
-- @param String String The message template containing placeholders
-- @param args Table A key-value table with placeholders and values
-- @return String The parsed message with placeholders replaced by their corresponding values
local function parseMessageTemplate(String, args)

    -- Iterate over the provided arguments and replace placeholders in the message template
    local message = String

    for placeholder, value in _pairs(args) do
        message = message:gsub(placeholder, value)
    end

    return message
end

--- Retrieves the event configuration for an "OnDeath" event based on the provided event type.
-- @param eventName String The name of the event
-- @param eventType number The event type
-- @return Table|nil The event configuration if found, otherwise nil
local function getDeathConfig(eventName, eventType)
    if (eventName ~= "OnDeath") then
        return nil
    end
    local eventConfig = config.events["OnDeath"][eventType]
    return eventConfig.enabled and eventConfig or nil
end

local function getScoreConfig(eventName, eventType)
    if (eventName ~= "OnScore") then
        return nil
    end

    local eventConfig = config.events["OnScore"][eventType]
    return eventConfig.enabled and eventConfig or nil
end

--- Adds a new event notification to the "halo-events.json" database, which will be processed by the Java Bot.
-- @param eventName String The name of the event
-- @param args Table The arguments for the event, used to parse message templates
-- @return nil
local function notify(eventName, args)

    -- Retrieve the event configuration based on the provided event name
    local eventConfig = config.events[eventName]
    local deathConfig = getDeathConfig(eventName, args.eventType)
    local scoreConfig = getScoreConfig(eventName, args.eventType)

    if (eventName ~= "OnDeath" and eventName ~= "OnScore" and not eventConfig.enabled)
            or (eventName == "OnDeath" and not deathConfig)
            or (eventName == "OnScore" and not scoreConfig) then
        return
    end

    -- Retrieve the title, description, color, and channel for the event
    local title = eventConfig.title
    local description = eventConfig.description
    local color = eventConfig.color or config.defaultColor
    local channel = eventConfig.channel

    -- Check if the event is an "OnDeath" event and update the embed details accordingly
    local embedTitle, embedDescription, embedColor, embedChannel
    if deathConfig then
        embedTitle = deathConfig.title
        embedDescription = deathConfig.description
        embedColor = deathConfig.color or config.defaultColor
        embedChannel = deathConfig.channel
        goto next
    elseif (scoreConfig) then
        embedTitle = scoreConfig.title
        embedDescription = scoreConfig.description
        embedColor = scoreConfig.color or config.defaultColor
        embedChannel = scoreConfig.channel
        goto next
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

    -- Update the JSON data file with the new event notification
    local jsonData = getJSONData()
    local serverEvents = jsonData[config.serverID].sapp_events

    _insert(serverEvents, {
        title = embedTitle,
        description = message,
        color = embedColor,
        channel = embedChannel
    })

    serverData.sapp_events = serverEvents
    jsonData[config.serverID] = serverData
    updateJSONData(jsonData)
end

--- Retrieves a tag value based on the provided type and name.
-- @param Type String The type of the tag
-- @param Name String The name of the tag
-- @return number|nil The tag value if found, otherwise nil
local function getTag(Type, Name)

    -- Look up the tag based on the provided type and name.
    -- Check if a valid tag was found, and if so, return the corresponding value
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function exclude(isQuit, playerToCompare, playerToExclude)

    if (not isQuit) then
        -- player joined, do not exclude
        return false
    end

    return playerToCompare == playerToExclude
end

--- Retrieves a list of players currently on the server.
-- @return Table A table containing the names of all players on the server
local function getPlayerList(isQuit, excludeThisPlayer)
    local playerList = {}
    for i = 1, 16 do
        if player_present(i) then
            local player = players[i]
            if player and not exclude(isQuit, i, excludeThisPlayer) then
                _insert(playerList, "- " .. player.name)
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
    game_type = get_var(0, "$gt")
    if game_type == 'n/a' then
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
    local timeStamp = _date(config.timeStampFormat)
    local level = _tonumber(get_var(player.id, '$lvl'))

    player.level = level -- update their level in case it was changed during the game

    local totalPlayers = getTotalPlayers(isQuit)
    serverData.status["Total Players"] = totalPlayers
    serverData.status["Player List"] = getPlayerList(isQuit, player.id) -- exclude the player who quit (if it's a quit event)

    -- Return a table containing player information
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
        notify("OnJoin", getJoinQuit(player, false))
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
        players[id].lapTime = _clock()
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
            ["$team"] = player.team,
            ["$playerID"] = player.id
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
            ["$playerName"] = player.name,
            ["$playerID"] = player.id
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
            ["$playerName"] = player.name,
            ["$playerID"] = player.id
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

    -- Retrieve the player object and validate its existence
    local player = players[id]

    if (player and id > 0) then

        -- Check if the message is a command
        local msg = message:match("^(%S+)")

        if (not isCommand(msg)) then

            -- Send an "OnChat" event notification
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

local function formatTime(lapTime)
    local minutes = _floor(lapTime / 60)
    local seconds = _floor(lapTime % 60)
    local milliseconds = _floor((lapTime * 1000) % 1000)
    return _format("%02d:%02d.%03d", minutes, seconds, milliseconds)
end

function OnScore(id)
    local player = players[id]
    if player then

        local eventType

        if game_type == "ctf" then
            eventType = 1
        elseif (game_type == "race") then
            eventType = not ffa and 2 or 3
            player.lapTime = formatTime(_clock() - player.lapTime)
        elseif (game_type == "slayer") then
            eventType = not ffa and 4 or 5
        end

        local score = get_var(id, "$score")
        local redScore = get_var(0, "$redscore")
        local blueScore = get_var(0, "$bluescore")

        notify("OnScore", {
            ["eventType"] = eventType,
            ["$lapTime"] = player.lapTime or "N/A",
            ["$totalTeamLaps"] = player.team == "red" and redScore or blueScore,
            ["$playerScore"] = score,
            ["$playerName"] = player.name,
            ["$playerTeam"] = player.team or "FFA",
            ["$redScore"] = redScore or "N/A",
            ["$blueScore"] = blueScore or "N/A",
        })
    end
end

--- Called when a player dies, sends an "OnDeath" event notification with details about the death.
-- @param victimIndex number The victim's index ID
-- @param killerIndex number The killer's index ID (0 for world kills, -1 for server kills)
-- @param metaID number The player's meta ID
-- @return nil
function OnDeath(victimIndex, killerIndex, metaID)

    -- Convert the index IDs to numbers
    victimIndex = _tonumber(victimIndex)
    killerIndex = _tonumber(killerIndex)

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
            ["$killerName"] = killerPlayer and killerPlayer.name or "N/A",
            ["$victimName"] = killerPlayer and victimPlayer.name or "N/A",
            ["$killerID"] = killerPlayer and killerPlayer.id or "N/A",
            ["$victimID"] = victimPlayer and victimPlayer.id or "N/A",
        })
    end
end

function OnScriptUnload()
    -- N/A
end