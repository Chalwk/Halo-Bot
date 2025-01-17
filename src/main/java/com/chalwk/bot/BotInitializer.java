package com.chalwk.bot;

import com.chalwk.CommandManager.CommandListener;
import com.chalwk.commands.channel;
import com.chalwk.util.Listeners.GuildReady;
import com.chalwk.util.authentication;
import net.dv8tion.jda.api.OnlineStatus;
import net.dv8tion.jda.api.entities.Activity;
import net.dv8tion.jda.api.requests.GatewayIntent;
import net.dv8tion.jda.api.sharding.DefaultShardManagerBuilder;
import net.dv8tion.jda.api.sharding.ShardManager;
import net.dv8tion.jda.api.utils.MemberCachePolicy;

import java.io.IOException;

public class BotInitializer {

    // ShardManager instance for managing bot shards.
    public static ShardManager shardManager;

    // Authentication token for the bot.
    private final String token;

    private static final String GAME_NAME = "Halo: PC";
    private static final OnlineStatus STATUS = OnlineStatus.ONLINE;

    /**
     * Constructs a BotInitializer and retrieves the authentication token.
     *
     * @throws IOException If an I/O error occurs while retrieving the token.
     */
    public BotInitializer() throws IOException {
        this.token = authentication.getToken();
    }

    /**
     * Initializes the bot with the specified settings and registers event listeners.
     *
     * @throws IOException If an I/O error occurs during initialization.
     */
    public void initializeBot() throws IOException {
        try {
            DefaultShardManagerBuilder builder = DefaultShardManagerBuilder.createDefault(this.token)
                    .setStatus(STATUS)
                    .setActivity(Activity.playing(GAME_NAME))
                    .setMemberCachePolicy(MemberCachePolicy.ALL)
                    .enableIntents(GatewayIntent.GUILD_MEMBERS,
                            GatewayIntent.GUILD_MESSAGES,
                            GatewayIntent.GUILD_PRESENCES,
                            GatewayIntent.MESSAGE_CONTENT);

            shardManager = builder.build();
            shardManager.addEventListener(new GuildReady());
            registerCommands(shardManager);
        } catch (Exception e) {
            // Log or handle the exception as appropriate
            System.err.println("Error initializing the bot: " + e.getMessage());
            throw e; // Re-throw if necessary or handle it accordingly
        }
    }

    /**
     * Registers commands with the ShardManager.
     *
     * @param shardManager The ShardManager to register commands with.
     */
    private void registerCommands(ShardManager shardManager) {
        CommandListener commands = new CommandListener();
        commands.add(new channel()); // Ensure the command class name reflects its purpose
        shardManager.addEventListener(commands);
    }
}
