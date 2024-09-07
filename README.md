# Description:

This bot serves as a custom bridge between Halo 1 (PC/CE) and Discord, enhancing the gaming experience by
keeping your Discord community up-to-date with in-game events. It sends customizable event notifications to
Discord channels, making it easy for server members to stay informed about what's happening in the game.

### Events:

| EVENT             | DESCRIPTION                   |
|-------------------|-------------------------------|
| event_chat        | A player sends a chat message |
| event_command     | A player executes a command   |
| event_game_start  | A new game starts             |
| event_game_end    | A game ends                   |
| event_join        | A player joins the server     |
| event_leave       | A player leaves the server    |
| event_die         | A player dies                 |
| event_snap        | A player snaps                |
| event_spawn       | A player spawns               |
| event_login       | A player logs in              |
| event_team_switch | A player switches teams       |
| event_score       | A player scores               |
| script_load       | This script is loaded         |
| script_unload     | This script is unloaded       |
| event_map_reset   | The map is reset              |

### Key Features:

* Real-time notifications for various in-game events
* Customizable embed messages, including title, description, color, and designated channel
* Enable/disable specific events

#### Coming in future updates:

* Two-way text communication between Discord and Halo (chat relay).
  > This feature will allow players to send messages from Discord to the game and vice versa.
  Currently, only game events are sent to Discord.
* Support to execute SAPP commands from Discord.
  > This feature will allow server admins to execute SAPP commands from Discord.
* Support for custom event notifications.
  > This feature will allow server admins to create custom event notifications for specific events.

# Installation

### Prerequisites:

- Must have Java 17 installed.
- For Windows users, you can download [Java 17 here](https://www.oracle.com/java/technologies/downloads/#jdk17-windows).
- For Linux users, run this command in your terminal: `sudo apt install openjdk-17-jre-headless`
- You will need a file decompression tool like [WinRAR](https://www.win-rar.com/start.html?&L=0)
  or [7-zip](https://www.7-zip.org/download.html) to extract **Halo-Bot.zip**.

## Installation steps:

- Place the **Discord.lua** script in the server *Lua folder*.
- Place the **Halo-Bot** folder in the server root directory (the same location as *sapp.dll* & *strings.dll*).

Once you have copied the necessary files to the server, follow these steps:

- Register an application on the [Discord Developer Portal](https://discord.com/developers/applications).

There are many tutorials online to help you learn how to create a Discord Application, however, as a general guide,
follow these steps:

- Click **New Application**.
  Provide a name for your bot and click **create**.
- Click the **Bot** tab on the left-hand side menu.
  Set the bot's username and profile picture.
- Click **Reset Token** and then **Yes, do it!**.
- Copy and paste the token into the *./Halo-Bot/auth.token* file. Never share this token with anyone.
- On the same page, scroll down to **Privileged Gateway Intents**.
- Enable **Presence Intent**, **Server Members Intent** and **Message Content Intent**.
- Click the **OAuth2** tab on the left-hand side menu.
  Click the sub-menu **OAuth2 URL Generator**.
  Under **Scopes**, select **bot**.
  Under **Bot Permissions**, select **Administrator**
  Copy the URL that gets generated and paste it into your browser.
- Select the server you want to add the bot to and click **Continue**.
  Click **Authorize**.
  Complete the captcha and click **Authorize**.
  The bot should now be on your Discord server.

### Starting the bot:

- Run the **RUN BOT.bat** file.
- The bot will automatically connect to the Discord API and start listening for events.
- You can now customize the event settings by editing the *Discord.lua* file.