--[[

/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

Script Name: Discord, for SAPP (PC & CE)
Description: This script will send sapp event notifications to the Halo Discord Bot, which will then be displayed in a Discord channel.

Events:
    - script_load               When this script is loaded
    - script_unload             When this script is unloaded
    - event_chat                When a player sends a chat message
    - event_command             When a player executes a command
    - event_game_start          When a new game starts
    - event_game_end            When a game ends
    - event_prejoin             When a player attempts to join the server
    - event_join                When a player joins the server
    - event_leave               When a player leaves the server
    - event_die                 When a player dies
    - event_snap                When a player snaps
    - event_spawn               When a player spawns
    - event_login               When a player logs in
    - event_map_reset           When the map is reset
    - event_team_switch         When a player switches teams

This script is highly customizable. You can enable/disable certain notifications and change the color of the text.
]]--

local config = {

    --
    -- General settings:
    --

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
        channelID = "1280417571837055022",
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
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnEnd"] = {
            -- Available placeholders: $map, $mode, $totalPlayers, $faa
            enabled = true,
            title = "🌅 The game has ended!",
            description = "The game ended with $totalPlayers players.",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnPreJoin"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers
            enabled = true,
            title = "🌐 Player attempting to connect to the server...",
            description = "Player: $playerName",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnJoin"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers
            enabled = true,
            title = "🟢 Player has joined the server!",
            description = "Player: $playerName",
            color = "GREEN",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- OnQuit:
        ["OnQuit"] = {
            -- Available placeholders: $playerName, $ipAddress, $cdHash, $indexID, $privilegeLevel, $joinTime, $ping, $totalPlayers
            enabled = true,
            title = "🔴 Player has left the server!",
            description = "Player: $playerName",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnSpawn"] = {
            -- Available placeholders: $playerName
            enabled = true,
            title = "🐣 Player has spawned!",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- OnSwitch:
        ["OnSwitch"] = {
            -- Available placeholders: $playerName, $team
            enabled = true,
            title = "👥 Player has switched teams!",
            description = "Player: $playerName switched teams. New team: [$team]",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        -- OnWarp:
        ["OnWarp"] = {
            -- Available placeholders: $playerName
            enabled = true,
            title = "𒅒 Player is warping...",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnReset"] = {
            -- Available placeholders: $map, $mode
            enabled = true,
            title = "🔄 The map has been reset!",
            description = "Map: [$map / $mode]",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnLogin"] = {
            -- Available placeholders: $playerName
            enabled = true,
            title = "👤 Player has logged in!",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnSnap"] = {
            -- Available placeholders: $playerName
            enabled = true,
            title = "⊹ Player has snapped!",
            description = "Player: $playerName",
            color = "YELLOW",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnCommand"] = {
            -- Available placeholders: $type, $name, $id, $cmd
            enabled = true,
            title = "⌘ Command executed!",
            description = "[$type] $name ($id): $cmd",
            color = "RED",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnChat"] = {
            -- Available placeholders: $type, $name, $id, $msg
            enabled = true,
            title = "🗨️ Chat message sent!",
            description = "[$type] $name ($id): $msg",
            color = "BLUE",
            channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        ["OnDeath"] = {
            [1] = {
                -- first blood
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ First blood!",
                description = "$killerName drew first blood",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [2] = {
                -- killed from the grave
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Killed from the grave!",
                description = "$victimName was killed from the grave by $killerName",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [3] = {
                -- vehicle kill
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Vehicle kill!",
                description = "$victimName was run over by $killerName",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [4] = {
                -- pvp
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ PvP kill!",
                description = "$victimName was killed by $killerName",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [5] = {
                -- guardians
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Guardians kill!",
                description = "$victimName was killed by the guardians",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [6] = {
                -- suicide
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Suicide!",
                description = "$victimName committed suicide",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [7] = {
                -- betrayal
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Betrayal!",
                description = "$victimName was betrayed by $killerName",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [8] = {
                -- squashed by a vehicle
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Squashed by a vehicle!",
                description = "$victimName was squashed by a vehicle",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [9] = {
                -- fall damage
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Fall Damage!",
                description = "$victimName fell and broke their leg",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [10] = {
                -- killed by the server
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Kill by the server!",
                description = "$victimName was killed by the server",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
            },
            [11] = {
                -- unknown death
                -- Available placeholders: $killerName, $victimName
                enabled = true,
                title = "☠️ Unknown death!",
                description = "$victimName died",
                color = "RED",
                channel = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
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

local function getJSONData()
    local file = io.open(config.jsonEventsPath, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return json:decode(content)
    end
    return nil
end

local function updateJSONData(t)
    local file = io.open(config.jsonEventsPath, "w")
    if file then
        file:write(json:encode_pretty(t))
        file:close()
    end
end

function OnScriptLoad()

    register_callback(cb['EVENT_CHAT'], 'OnChat')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')

    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_PREJOIN'], 'OnPreJoin')

    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    register_callback(cb['EVENT_SNAP'], 'OnSnap')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_LOGIN'], 'OnLogin')
    register_callback(cb['EVENT_MAP_RESET'], "OnReset")
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')

    local status = config.STATUS_SETTINGS
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

    local jsonData = getJSONData() or {}
    jsonData[config.serverID] = serverData
    updateJSONData(jsonData)

    OnStart(true)
end

local function getTotalPlayers(isQuit)
    local total = tonumber(get_var(0, "$pn"))
    return (isQuit and total - 1 or total)
end

local function parseMessageTemplate(String, args)
    local message = String
    for placeholder, value in pairs(args) do
        message = message:gsub(placeholder, value)
    end
    return message
end

local function notify(eventName, args)

    local eventConfig = config.events[eventName]
    if (not eventConfig.enabled) then
        return
    end

    local title = eventConfig.title
    local description = eventConfig.description
    local color = eventConfig.color or config.defaultColor
    local channel = eventConfig.channel

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

    embedTitle = title
    embedDescription = description
    embedColor = color
    embedChannel = channel

    :: next ::

    local message = parseMessageTemplate(embedDescription, args)
    embedTitle = parseMessageTemplate(embedTitle, args)

    local jsonData = getJSONData()
    table.insert(serverData.sapp_events, {
        title = embedTitle,
        description = message,
        color = embedColor,
        channel = embedChannel
    })
    jsonData[config.serverID] = serverData
    updateJSONData(jsonData)
end

local function getTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnStart(OnScriptLoad)

    if get_var(0, '$gt') == 'n/a' then
        return
    end

    players = { }
    first_blood = true

    ffa = (get_var(0, '$ffa') == '1')

    falling = getTag('jpt!', 'globals\\falling')
    distance = getTag('jpt!', 'globals\\distance')

    map = get_var(0, "$map")
    mode = get_var(0, "$mode")

    local playerList = {}
    for i = 1, 16 do
        if player_present(i) then
            OnJoin(i, OnScriptLoad)
            local player = players[i]
            if player then
                table.insert(playerList, player.name)
            end
        end
    end

    serverData.status["Map"] = map
    serverData.status["Mode"] = mode
    serverData.status["Total Players"] = getTotalPlayers()
    serverData.status["Player List"] = playerList

    notify("OnStart", {
        ["$totalPlayers"] = getTotalPlayers(),
        ["$map"] = map,
        ["$mode"] = mode,
        ["$faa"] = (ffa and "FFA" or "Team Play")
    })
end

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

local function getJoinQuit(player, isQuit)
    local level = tonumber(get_var(player.id, '$lvl'))
    local timeStamp = date(config.timeStampFormat)
    local ping = get_var(player.id, "$ping")
    return {
        ["$playerName"] = player.name,
        ["$ipAddress"] = player.ip,
        ["$cdHash"] = player.hash,
        ["$indexID"] = player.id,
        ["$privilegeLevel"] = level,
        ["$joinTime"] = timeStamp,
        ["$ping"] = ping,
        ["$totalPlayers"] = getTotalPlayers(isQuit)
    }
end

function OnPreJoin(id)
    players[id] = {
        level = tonumber(get_var(id, '$lvl')),
        id = id,
        meta = 0,
        switched = false,
        ip = get_var(id, '$ip'),
        name = get_var(id, '$name'),
        team = get_var(id, '$team'),
        hash = get_var(id, '$hash')
    }
    local player = players[id]
    if (player) then
        notify("OnPreJoin", getJoinQuit(player))
    end
end

function OnJoin(id, OnScriptLoad)
    local player = players[id]
    if (player and not OnScriptLoad) then
        serverData.status["Total Players"] = getTotalPlayers()
        notify("OnJoin", getJoinQuit(player))
    end
end

function OnSpawn(id)
    local player = players[id]
    if player then
        players[id].meta = 0
        players[id].switched = nil
        notify("OnSpawn", {
            ["$playerName"] = player.name
        })
    end
end

function OnQuit(id)
    local player = players[id]
    if (player) then
        serverData.status["Total Players"] = getTotalPlayers()
        notify("OnQuit", getJoinQuit(player, true))
    end
    players[id] = nil
end

function OnSwitch(id)
    local player = players[id]
    if player then
        player.team = get_var(id, '$team') -- new team
        player.switched = true
        notify("OnSwitch", {
            ["$playerName"] = player.name,
            ["$team"] = player.team
        })
    end
end

function OnWarp(id)
    local player = players[id]
    if player then
        notify("OnWarp", {
            ["$playerName"] = player.name
        })
    end
end

function OnReset()
    notify("OnReset", {
        ["$map"] = get_var(0, "$map"),
        ["$mode"] = get_var(0, "$mode")
    })
end

function OnLogin(id)
    local player = players[id]
    if (player) then
        notify("OnLogin", {
            ["$playerName"] = player.name
        })
    end
end

function OnSnap(id)
    local player = players[id]
    if (player) then
        notify("OnSnap", {
            ["$playerName"] = player.name
        })
    end
end

local command_type = {
    [0] = "rcon command",
    [1] = "console command",
    [2] = "chat command",
    [3] = "unknown command type"
}

function OnCommand(id, command, environment)
    local player = players[id]
    if (player and id > 0) then
        local cmd = command:match("^(%S+)")
        notify("OnCommand", {
            ["$type"] = command_type[environment],
            ["$name"] = player.name,
            ["$id"] = id,
            ["$cmd"] = cmd
        })
    end
end

local chat_type = {
    [0] = "GLOBAL",
    [1] = "TEAM",
    [2] = "VEHICLE",
    [3] = "UNKNOWN"
}

local function isCommand(str)
    return (str:sub(1, 1) == "/" or str:sub(1, 1) == "\\")
end

function OnChat(id, message, environment)
    local player = players[id]
    if (player and id > 0) then
        local msg = message:match("^(%S+)")
        if (not isCommand(msg)) then
            notify("OnChat", {
                ["$type"] = chat_type[environment],
                ["$name"] = player.name,
                ["$id"] = id,
                ["$msg"] = message
            })
        end
    end
end

function OnDeath(victimIndex, killerIndex, metaID)

    victimIndex = tonumber(victimIndex)
    killerIndex = tonumber(killerIndex)

    local victimPlayer = players[victimIndex]
    local killerPlayer = players[killerIndex]

    if victimPlayer then

        if metaID then
            victimPlayer.meta = metaID
            return true
        end

        local squashed = (killerIndex == 0)
        local guardians = (killerIndex == nil)
        local suicide = (killerIndex == victimIndex)
        local pvp = (killerIndex > 0 and killerIndex ~= victimIndex)
        local server = (killerIndex == -1 and not victimPlayer.switched)
        local fell = (victimPlayer.meta == falling or victimPlayer.meta == distance)
        local betrayal = (killerPlayer and not ffa and victimPlayer.team == killerPlayer.team and killerIndex ~= victimIndex)

        local eventType
        if pvp and not betrayal then

            if first_blood then
                first_blood = false
                eventType = 1
                goto done
            end

            -- killed from the grave
            if not player_alive(killerIndex) then
                eventType = 2
                goto done
            end

            -- vehicle kill
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