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
    STATUS_SETTINGS = {

        -- The channel ID where the bot will update the server status message.
        -- This message includes details such as server name, IP, map, mode, and total players.
        channelID = "xxxxxxxxxxxxxxxxxxx",

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
    -- enabled (boolean):       Whether the event notification is enabled
    -- title (string):          The title of the embed message
    -- description (string):    The description of the embed message
    -- color (string):          The color of the embed message
    -- channel (string):        The channel ID where the embed message will be sent

    -- Event-specific settings:
    events = {
        ["OnStart"] = {
            -- Available placeholders: $map, $mode, $totalPlayers, $faa
            enabled = true,
            title = "🌄 A new game has started!",
            description = "- Map: [**$map**]\n- [**$mode**] (**$faa**)\n- Players: **$totalPlayers**",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnEnd"] = {
            -- Available placeholders: $map, $mode, $totalPlayers, $faa
            enabled = true,
            title = "🌅 The game has ended!",
            description = "The game ended with **$totalPlayers** players.",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnJoin"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers, $playerID
            enabled = true,
            title = "🟢 $playerName has joined the server!",
            description = "",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        -- OnQuit:
        ["OnQuit"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers, $playerID
            enabled = true,
            title = "🔴 $playerName has left the server!",
            description = "",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnSpawn"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = false,
            title = "🐣 $playerName has spawned!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        -- OnSwitch:
        ["OnSwitch"] = {
            -- Available placeholders: $playerName, $team, $playerID
            enabled = true,
            title = "👥 Player has switched teams!",
            description = "**$playerName** switched teams. New team: **[$team]**",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        -- OnWarp:
        ["OnWarp"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = true,
            title = "𒅒 $playerName is warping...",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnReset"] = {
            -- Available placeholders: $map, $mode
            enabled = true,
            title = "🔄 The map has been reset!",
            description = "- **$map**\n- **$mode**",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnLogin"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = false,
            title = "👤 $playerName has logged in!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnSnap"] = {
            -- Available placeholders: $playerName, $playerID
            enabled = false,
            title = "⊹ $playerName snapped!",
            description = "",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnCommand"] = {
            -- Available placeholders: $type, $name, $id, $command, $playerID
            enabled = false,
            title = "⌘ Command executed!",
            description = "[**$type**] **$playerName** (**$id**): *$command*",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnChat"] = {
            -- Available placeholders: $type, $playerName, $id, $message, $playerID
            enabled = true,
            title = "🗨️ Chat message sent!",
            description = "[**$type**] **$playerName** (**$id**): *$message*",
            color = "BLUE",
            channel = "xxxxxxxxxxxxxxxxxxx"
        },
        ["OnScore"] = {
            [1] = {
                -- Available placeholders: $playerName, $playerTeam, $redScore, $blueScore
                enabled = true,
                title = "🏆 CTF Scoreboard updated!",
                description = "$playerName captured the flag for the **$playerTeam team**\n- Red Team Score: **$redScore**\n- Blue Team Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $playerTeam, $lapTime, $totalTeamLaps
            [2] = {
                enabled = true,
                title = "🏆 Team RACE Scoreboard updated!",
                description = "$playerName completed a lap for the $playerTeam team\n- Lap Time: **$lapTime**\n- Total Laps: **$totalTeamLaps**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $lapTime, $playerScore
            [3] = {
                enabled = true,
                title = "🏆 FFA RACE Scoreboard updated!",
                description = "$playerName completed a lap\n- Lap Time: **$lapTime**\n- Total Laps: **$playerScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $playerTeam, $redScore, $blueScore
            [4] = {
                enabled = true,
                title = "🏆 Team Slayer Scoreboard updated!",
                description = "$playerName scored for the **$playerTeam team**\n- Red Team Score: **$redScore**\n- Blue Team Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            -- Available placeholders: $playerName, $redScore, $blueScore
            [5] = {
                enabled = true,
                title = "🏆 FFA Slayer Scoreboard updated!",
                description = "$playerName scored\n- Red Team Score: **$redScore**\n- Blue Team Score: **$blueScore**",
                color = "GREEN",
                channel = "xxxxxxxxxxxxxxxxxxx"
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
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [2] = {
                -- killed from the grave
                enabled = true,
                title = "☠️ $victimName was killed from the grave by $killerName",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [3] = {
                -- vehicle kill (includes being run over or killed by the vehicle's weapon)
                -- In order to preserve support for custom maps that have custom vehicle tag ids, the script will not check for the vehicle tag id.
                -- Instead we send a generic message for all vehicle kills.
                enabled = true,
                title = "☠️ $victimName was killed by $killerName",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [4] = {
                -- pvp
                enabled = true,
                title = "☠️ $victimName was killed by $killerName",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [5] = {
                -- guardians
                enabled = true,
                title = "☠️ $victimName was killed by the guardians",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [6] = {
                -- suicide
                enabled = true,
                title = "☠️ $victimName committed suicide!",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [7] = {
                -- betrayal
                enabled = true,
                title = "☠️ $victimName was betrayed by $killerName!",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [8] = {
                -- squashed by a vehicle (when an unoccupied vehicle collides with you)
                enabled = true,
                title = "☠️ $victimName was squashed by a vehicle",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [9] = {
                -- fall damage
                enabled = true,
                title = "☠️ $victimName fell and broke their leg",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [10] = {
                -- killed by the server
                enabled = true,
                title = "☠️ $victimName was killed by the server",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
            },
            [11] = {
                -- unknown death
                enabled = true,
                title = "☠️ $victimName died",
                description = "",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxx"
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

    -- Trigger OnStart with a new game event.
    -- This is necessary for the script to work properly if loaded during a game.
    OnStart(true)
end

--- Calculates the total number of players on the server, taking into account whether a player has quit or not.
-- @param isQuit Boolean Indicates if a player has quit
-- @return number Total number of players
local function getTotalPlayers(isQuit)
    local total = _tonumber(get_var(0, "$pn"))
    return (isQuit and total - 1 or total)
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

--- Retrieves the event configuration based on the provided event name and type.
-- @param eventName String The name of the event
-- @param eventType number The type of the event
-- @return Table|nil The event configuration if found, otherwise nil
local function getEventConfig(eventName, eventType)
    local event = config.events[eventName]
    local altEvent = (eventName == "OnDeath" or eventName == "OnScore") and (event[eventType] or nil)

    if altEvent then
        return altEvent and altEvent.enabled and altEvent or nil
    end

    return event and event.enabled and event or nil
end

--- Sends an event notification to Discord based on the provided event name and arguments.
-- @param eventName String The name of the event
-- @param args Table A key-value table containing event-specific arguments
local function notify(eventName, args)

    -- Retrieve the event configuration based on the event name and type
    local eventConfig = getEventConfig(eventName, args.eventType)
    if not eventConfig then
        return
    end

    -- Retrieve the title, description, color, and channel from the event configuration
    local title = eventConfig.title
    local description = eventConfig.description
    local color = eventConfig.color or config.defaultColor
    local channel = eventConfig.channel

    -- Parse the title and description templates with the provided arguments
    local message = parseMessageTemplate(description, args)
    title = parseMessageTemplate(title, args)

    -- Insert the event into the serverData and update the JSON file
    local jsonData = getJSONData()
    local serverEvents = jsonData[config.serverID].sapp_events

    -- Insert the event into the serverEvents table
    _insert(serverEvents, {
        title = title,
        description = message,
        color = color,
        channel = channel
    })

    -- Update the serverData with the new event
    serverData.sapp_events = serverEvents

    -- Update the JSON file with the new serverData
    jsonData[config.serverID] = serverData
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

    game_type = get_var(0, "$gt")
    if game_type == 'n/a' then
        return
    end

    players = {}
    first_blood = true
    ffa = (get_var(0, '$ffa') == '1')

    falling = getTag('jpt!', 'globals\\falling')
    distance = getTag('jpt!', 'globals\\distance')

    map = get_var(0, "$map")
    mode = get_var(0, "$mode")

    -- Loop through player slots, add joined players to the list, and call OnJoin function.
    -- This is necessary to ensure that the player list is up-to-date when the game starts (if the script is loaded during a game).
    for i = 1, 16 do
        if player_present(i) then
            OnJoin(i, OnScriptLoad)
        end
    end

    local totalPlayers = getTotalPlayers()

    serverData.status["Map"] = map
    serverData.status["Mode"] = mode
    serverData.status["Total Players"] = totalPlayers
    serverData.status["Player List"] = getPlayerList()

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

    serverData.status["Map"] = "Loading new Map..."
    serverData.status["Mode"] = "N/A"

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

    local player = players[id]
    if player and not OnScriptLoad then
        notify("OnJoin", getJoinQuit(player, false))
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
            end

            if not player_alive(killer) then
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