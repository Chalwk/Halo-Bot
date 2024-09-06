/* Copyright (c) 2024 Jericho Crosby <jericho.crosby227@gmail.com>. Licensed under GNU General Public License v3.0.
   See the LICENSE file or visit https://www.gnu.org/licenses/gpl-3.0.en.html for details. */

package com.chalwk.bot;

import com.chalwk.CommandManager.CommandListener;
import com.chalwk.commands.channel;
import com.chalwk.util.EventProcessingTask;
import com.chalwk.util.FileIO;
import com.chalwk.util.Listeners.GuildReady;
import com.chalwk.util.Logging.Logger;
import com.chalwk.util.StatusMonitor;
import com.chalwk.util.authentication;
import net.dv8tion.jda.api.OnlineStatus;
import net.dv8tion.jda.api.entities.Activity;
import net.dv8tion.jda.api.requests.GatewayIntent;
import net.dv8tion.jda.api.sharding.DefaultShardManagerBuilder;
import net.dv8tion.jda.api.sharding.ShardManager;
import net.dv8tion.jda.api.utils.MemberCachePolicy;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

/**
 * A class responsible for initializing and setting up the bot for the Virtual Pets game project.
 */
public class BotInitializer {

    /**
     * An instance of the PetDataHandler class to manage pet data.
     */
    public static ShardManager shardManager;

    private static final Set<String> monitoredServers = new HashSet<>();

    /**
     * The bot's authentication token.
     */
    private final String token;

    /**
     * Constructs a BotInitializer instance and retrieves the bot's authentication token.
     *
     * @throws IOException if there's an error reading the token file.
     */
    public BotInitializer() throws IOException {
        this.token = authentication.getToken();
    }

    public static ShardManager getShardManager() {
        return shardManager;
    }

    /**
     * Initializes the bot and sets up event listeners and commands.
     */
    public void initializeBot() throws IOException {

        DefaultShardManagerBuilder builder = DefaultShardManagerBuilder.createDefault(this.token)
                .setStatus(OnlineStatus.ONLINE)
                .setActivity(Activity.playing("Halo: PC"))
                .setMemberCachePolicy(MemberCachePolicy.ALL)
                .enableIntents(GatewayIntent.GUILD_MEMBERS,
                        GatewayIntent.GUILD_MESSAGES,
                        GatewayIntent.GUILD_PRESENCES,
                        GatewayIntent.MESSAGE_CONTENT);

        shardManager = builder.build();
        shardManager.addEventListener(new GuildReady());
        registerCommands(shardManager);

        scheduleHaloDataProcessing();
    }

    private void scheduleHaloDataProcessing() {
        Timer timer = new Timer();
        TimerTask haloDataTask = new TimerTask() {
            @Override
            public void run() {
                try {
                    processHaloData();
                } catch (IOException e) {
                    Logger.info("Error processing halo data: " + e.getMessage());
                }
            }
        };
        timer.schedule(haloDataTask, 0, 1000 * 30);
    }

    private void processHaloData() throws IOException {
        JSONObject parentTable = FileIO.getJSONObjectFromFile("halo-events.json");

        for (String serverID : parentTable.keySet()) {
            if (!monitoredServers.contains(serverID)) {
                new StatusMonitor(serverID, 30);
                new EventProcessingTask(serverID, 1);
                monitoredServers.add(serverID);
            }
        }
    }

    /**
     * Registers the available commands for the bot.
     *
     * @param shardManager The ShardManager instance used to manage the bot.
     */
    private void registerCommands(ShardManager shardManager) {
        CommandListener commands = new CommandListener();
        commands.add(new channel());
        shardManager.addEventListener(commands);
    }
}
