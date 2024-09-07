# Halo-Bot

The Halo Bot is a custom bridge between Halo 1 (PC/CE) and Discord, designed to enhance the gaming experience by keeping
your Discord community up-to-date with in-game events. This bot sends customizable event notifications to Discord
channels, making it easy for your server members to stay informed about what's happening in the game.

## Features

Real-time notifications for various in-game events:

- Player joins/leaves the server
- Player sends a chat message
- Player executes a command
- Player dies
- Player snaps
- Player spawns
- Player logs in
- Player switches teams
- Player scores
- Game starts/ends
- Map resets

Customizable event notifications:

- Enable/disable specific events
- Customize the message format for each event
- Customize the channel where each event is sent
- Customize the color of the embed message for each event

## Installation

### Prerequisites:

- Must have Java 17 installed.
- For Windows users, you can download [Java 17 here](https://www.oracle.com/java/technologies/downloads/#jdk17-windows).
- For Linux users, run this command in your terminal: `sudo apt install openjdk-17-jre-headless`
- You will need a file decompression tool like [WinRAR](https://www.win-rar.com/start.html?&L=0)
  or [7-zip](https://www.7-zip.org/download.html) to extract **Halo Bot.zip**.

### Installation steps:

- Place the **Discord.lua** script in the server *Lua folder*.
- Place the **Halo Bot** folder in the server root directory (the same location as *sapp.dll* & *strings.dll*).

Once you have copied the necessary files to the server, follow these steps:

- Register an application on the [Discord Developer Portal](https://discord.com/developers/applications) and obtain a *
  *bot token**.

> A Discord bot token is a short phrase (represented as a jumble of letters and numbers) that acts as a key to
> controlling a Bot. It is used to authenticate the Bot and establish a connection to the Discord API.

There are many tutorials online to help you learn how to create a Discord Application, however, as a general guide,
follow these steps:

- Click **New Application**.
  Provide a name for your bot and click **create**.
- Click the **Bot** tab on the left-hand side menu.
  Set the bot's username and profile picture.
- Click **Reset Token** and then **Yes, do it!**.
- Copy and paste the token into the *./Halo Bot/auth.token* file. Never share this token with anyone.
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

- Run the **HaloBot-1.0.0.jar** file.
- The bot will automatically connect to the Discord API and start listening for events.
- You can now customize the event settings by editing the *Discord.lua* file.