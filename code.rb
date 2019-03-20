require 'discordrb'
require 'configatron'
require 'open-uri'
require_relative 'config.rb'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: 291_390_171_151_335_424, prefix: ['A^', '<@291390171151335424> '], ignore_bots: true

bot.bucket :normal, limit: 5, time_span: 15, delay: 3

bot.ready do |_event|
  sleep 180
  bot.game = 'Use A^cmds or A^info'
  sleep 180
  bot.game = "on #{bot.servers.count} servers!"
  redo
end

bot.command(:die, help_available: false) do |event|
  if event.user.id == 228_290_433_057_292_288
    bot.send_message(event.channel.id, 'CahBot Alpha is shutting down')
    exit
  else
    'Sorry, only Cah can kill me'
  end
end

bot.command(:eval, help_available: false) do |event, *_code|
  if event.user.id == 228_290_433_057_292_288
    begin
      event << 'Eval Complete!'
      event << ''
      event << "Output: ```#{eval event.message.content[6..-1]} ```"
    rescue => e
      event << 'Eval Failed!'
      event << ''
      event << "Output: ```#{e} ```"
    end
  else
    'Sorry, only Cah can eval stuff'
  end
end

bot.command(:report, help_available: false, min_args: 1) do |event, *_args|
  event.respond 'Alright, do you want me to send an invite as well?'
  event.user.await(:aaaaa, content: 'Yes' || 'Sure' || 'Yeah') do |event, *_args|
    begin
      event.respond 'Awesome, invite sent'
    rescue
      event.respond 'Ah geez, some sort of error occured, make sure I have permission to create invites in your general channel'
    end
  end
  nil
end

bot.command(:restart, help_available: false) do |event|
  if event.user.id == 228_290_433_057_292_288
    begin
      event.respond ['Into the ***fuuuutttttuuuuurrrreeee***', 'Please wait...', 'How about n—', 'Can do :thumbsup::skin-tone-1:', 'Pong! Hey, that took... Oh wait, wrong command', 'Ask again at a later ti—'].sample
      exec('bash restart.sh')
    end
  else
    'Sorry, only Cah can update me'
  end
end

bot.command(:set, help_available: false) do |event, action, *args|
  if event.user.id == 228_290_433_057_292_288
    case action
    when 'avatar'
      open(args.join(' ').to_s) { |pic| event.bot.profile.avatar = pic }
    when 'username'
      name = args.join(' ').to_s
      event.respond "Username set to `#{bot.profile.username = name}`"
    when 'game'
      bot.game = args.join(' ').to_s
      event.respond 'GAME SET!'
    when 'status'
      online = bot.on
      idle = bot.idle
      invis = bot.invisible
      dnd = bot.dnd
      eval args.join(' ')
      'Status Changed!'
    else
      'I don\'t know what to do!'
    end
  else
    'Sorry, only Cah can set stuff'
  end
end

bot.command(:ban, help_available: false, required_permissions: [:ban_members], permission_message: 'Heh, sorry, but you need the Ban Members permission to use this command', max_args: 1, min_args: 1, usage: 'A^ban <mention>') do |event, *args|
  bot_profile = bot.profile.on(event.server)
  can_do_the_magic_dance = bot_profile.permission?(:ban_members)
  if can_do_the_magic_dance == true
    if !event.message.mentions.empty?
      begin
        mention = bot.parse_mention(args.join.to_s).id
        event.server.ban(mention.to_s, message_days = 7)
        event.respond ["<@#{mention}> has been beaned, the past 7 days of messages from them have been deleted", "<@#{mention}> has been banned, the past 7 days of messages from them have been deleted"]
      rescue => e
        event.respond 'The user you are trying to ban has a role higher than/equal to me. If you believe this is a mistake, report this to the CB Server'
      else
        event.respond 'Sorry, but I do not have the "Ban Members" permission'
      end
    else
      event.respond 'Sorry, but you need to mention the person you want to ban'
    end
  end
end

bot.command(:kick, help_available: false, required_permissions: [:kick_members], permission_message: 'Heh, sorry, but you need the Kick Members permission to use this command', max_args: 1, min_args: 1, usage: 'A^kick <mention>') do |event, *args|
  bot_profile = bot.profile.on(event.server)
  can_do_the_other_magic_dance = bot_profile.permission?(:kick_members)
  if can_do_the_other_magic_dance == true
    if !event.message.mentions.empty?
      begin
        mention = bot.parse_mention(args.join.to_s).id
        event.server.kick(mention.to_i)
        event.respond ["<@#{mention}> has been keked", "<@#{mention}> has been kicked"]
      rescue => e
        event.respond 'The user you are trying to kick has a role higher than/equal to me. If you believe this is a mistake, report this to the CB Server'
      else
        event.respond 'Sorry, but I do not have the "Kick Members" permission'
      end
    else
      event.respond 'Sorry, but you need to mention the person you want to kick'
    end
  end
end

bot.command(:announce, help_available: false, min_args: 2, usage: 'A^announce nomention/mentioneveryone/embed <words>', required_permissions: [:kick_members], permission_message: 'Just because, only those with the Administrator permission can announce stuff') do |event, action, _words|
  begin
    case action
    when 'embed'
      bot.channel(bot.find_channel('announcements', server_name = event.server.name).to_s.split[2][3..-1]).send_embed do |e|
        e.title = "New Announcement (By #{event.user.distinct})!"
        e.description = event.message.content[16..-1]
        e.color = [11_736_341, 3_093_151, 2_205_818, 2_353_205, 12_537_412, 12_564_286,
                   3_306_856, 9_414_906, 3_717_172, 14_715_195, 3_813_410, 9_899_000,
                   16_047_888, 4_329_932, 12_906_212, 9_407_771, 1_443_384, 13_694_964,
                   6_157_013, 8_115_963, 9_072_972, 16_299_832, 15_397_264, 10_178_593,
                   7_701_739, 8_312_810, 13_798_754, 15_453_783, 12_107_214, 9_809_797,
                   2_582_883, 13_632_200, 12_690_287, 14_127_493].sample
      end
      event.message.delete
      event.respond "Announced successfully, <@#{event.user.distinct}>"
    when 'mentioneveryone'
      bot.channel(bot.find_channel('announcements', server_name = event.server.name).to_s.split[2][3..-1]).send_message "@everyone | **New Announcement (By #{event.user.distinct})!** \n \n#{event.message.content[28..-1]}"
      event.message.delete
      event.respond "Announced successfully, <@#{event.user.id}>"
    when 'nomention'
      bot.channel(bot.find_channel('announcements', server_name = event.server.name).to_s.split[2][3..-1]).send_message "**New Announcement (By #{event.user.distinct})!** \n \n#{event.message.content[21..-1]}"
      event.message.delete
      event.respond "Announced successfully, <@#{event.user.id}>"
    end
  rescue => e
    event.respond "Ah geez, something bad happened. This might be due to you not having an \#announcements channel."
  end
end

bot.command(:ping, help_available: false, max_args: 0, usage: 'A^ping') do |event|
  m = event.respond('Pinging!')
  m.edit "Pong! Hey, that took #{((Time.now - event.timestamp) * 1000).to_i}ms."
end

bot.command(%i[eightball eball 8ball], help_available: false, min_args: 1, usage: 'A^8ball <words>', bucket: :normal, rate_limit_message: 'Even the 8ball needs a break... (`%time%` seconds left)') do |event|
  event.respond ['Sources say... Yeah', 'Sources say... Nah', 'Perhaps', 'As I see it, yes', 'As I see it, no', 'If anything, probably', 'Not possible', 'Ask again at a later time', 'Say that again?', 'lol idk', 'Probably not', 'woahdude', '[object Object]', 'Undoubtfully so', 'I doubt it', 'Eh, maybe'].sample
end

bot.command(:roll, help_available: false, max_args: 0, usage: 'A^roll', bucket: :normal, rate_limit_message: 'There\'s no way you can roll a die that fast (`%time%` seconds left)') do |event|
  h = event.respond '**Rolling Dice!**'
  sleep [1, 2, 3].sample
  h.edit "And you got a... **#{rand(1..6)}!**"
end

bot.command(:flip, help_available: false, max_args: 0, usage: 'A^flip', bucket: :normal, rate_limit_message: 'There\'s no way you can flip a coin that fast (`%time%` seconds left)') do |event|
  m = event.respond '**Flipping Coin...**'
  sleep [1, 2, 3].sample
  m.edit ['woahdude, you got **Heads**', 'woahdude, you got **Tails**', 'You got **heads**', 'You got **tails**'].sample
end

bot.command(:flop, help_available: false, max_args: 0, usage: 'A^flop', bucket: :normal, rate_limit_message: 'There\'s no way you can coin a fast that flop (`%time%` seconds left)') do |event|
  m = event.respond ["Oops, the coin flipped so high it didn't come back down", 'The coin multiplied and landed on both', 'The coin... disappeared', "Pong! It took **#{((Time.now - event.timestamp) * 1000).to_i}ms** to ping the coin", "And you got a... **#{rand(1..6)}!** wait thats not how coins work", 'Perhaps you could resolve your situation without relying on luck', 'noot', '[Witty joke concerning flipping a coin]', '[BOTTOM TEXT]'].sample
end

bot.command(:info, help_available: false, max_args: 0, usage: 'A^info') do |event|
  event << '***Info About CahBot:***'
  event << ''
  event << '**Nani?** CahBot Alpha is the last living CB after shutting down the server'
  event << '**Who made CahBot?** Cah#6112 did, mostly'
  event << '**Why does CahBot exist?** A long time ago I wanted to make a discord bot people would actually use, I kinda failed'
  event << '**Does CahBot have a server or something?** No, servers are currently being fixed, for more updates, checkout https://cah.soarn.pro'
  event << '**u suk a bunnch an u can hardly mak a discord bawt.** Yeah, I know'
end

bot.command(:trello, help_available: false, max_args: 0, usage: 'A^trello') do |event|
  event.respond 'The Trello board for CahBot: https://cah.soarn.pro/trello'
end

bot.message(with_text: 'CBA prefix') do |event|
  event.respond 'My prefix is `A^`. For help, do `A^help`, for commands, do `A^cmds`, and for information, do `A^info`.'
end

bot.command(:rnumber, help_available: false, min_args: 2, max_args: 2, usage: 'A^rnumber <small num> <large num>') do |event, min, max|
  rand(min.to_i..max.to_i)
end

bot.command(:invite, help_available: false, max_args: 0, usage: 'A^invite') do |event|
  event.respond 'To invite me to your server, head over here: https://cah.soarn.pro/bot-invite'
end

bot.command(:say, help_available: false, required_permissions: [:manage_messages], permission_message: 'Sorry, you need the Manage Messages perm in order to use A^say') do |event, *_args|
  if event.message.content[6..-1].nil?
    "I can't hear you!"
  else
    event.message.delete
    event.respond event.message.content[6..-1].to_s
  end
end

bot.command(%i[reverse rev], help_available: false, min_args: 1, usage: '>sdrow< esrever^B') do |event, *args|
  args.join(' ').to_s.reverse
end

bot.command(:userinfo, help_available: false, max_args: 0, usage: 'A^userinfo') do |event|
  event << '**__User Info For You__**'
  event << ''
  event << "**User ID:** `#{event.user.id}`"
  event << "**User Discrim:** `#{event.user.discrim}`"
  event << "**Username:** `#{event.user.name}`"
  event << "**User Nickname:** `#{event.user.nick}`" unless event.user.nick.nil?
  event << "**User Game:** `#{event.user.game}`" unless event.user.game.nil?
  event << "**User Avatar:** https://cdn.discordapp.com/avatars/#{event.user.id}/#{event.user.avatar_id}.webp?size=1024"
end

bot.command(:thanks, help_available: false, max_args: 0, usage: 'A^thanks') do |event|
  event << 'Thanks so much to these current Donors:'
  event << 'ChewLeKitten#6216 - Cool Donor, Contributor, and an ultra-rad person'
  event << 'Soarn#7582 - donated once, supplied https://cah.soarn.pro '
  puts "^thanks | Command ran by #{event.user.name}\##{event.user.discriminator} (ID: #{event.user.id}) on server #{event.server.name} (ID: #{event.server.id})"
end

bot.command(%i[servercount servcount], help_available: false, max_args: 0, usage: 'A^servercount') do |event|
  event.respond "CahBot Alpha is on **#{bot.servers.count}** servers as of now"
end

bot.command(:donate, help_available: false, max_args: 0, usage: 'A^donate') do |event|
  event.respond "Hi #{event.user.name}, click here for donations: https://cah.soarn.pro/patreon Since the bot is shut down for the most part, I wouldn't recommend this"
end

bot.command(:help, help_available: false, max_args: 0, usage: 'A^help') do |event|
  event << ' woahdude, you looking for help? Well, here\'s what you need to know.'
  event << ' For a list of commands, you can do `A^cmds`, for info about CahBot, do `A^info`'
end

bot.command(:noot, help_available: false, max_args: 0, usage: 'A^noot') do |event|
  event.respond '**NOOT** https://cah.soarn.pro/noot.gif'
end

bot.command(%i[cmds commands], chain_usable: false, max_args: 0, usage: 'A^commands') do |event|
  event << 'Here are all of my commands for you to use!'
  event << '*__Cah\'s Commands__*'
  event << '`A^restart`: Pulls that fresh code and runs it, provided we don\'t run into a syntax error or anything'
  event << '`A^die`: Kills the bot, without pulling any code or anything'
  event << '`A^eval`: Like you don\'t know what eval commands do'
  event << '`A^set <avatar|username|game|status> <args>`: Sets stuff'
  event << ''
  event << '*__Moderation Commands (in the works)__*'
  event << '`A^ban <mention>`: Bans the user mentioned and deletes the past 7 days of messages from them'
  event << '`A^kick <mention>`: Kicks the user mentioned (A bit bugged, working on it)'
  event << '`A^say`: Makes CBA say something, you need the manage messages perm tho ~~yes I know it\'s not much of a moderation command shut up~~'
  event << ''
  event << '*__Fun Commands/Other Commands/Things I Was Too Lazy To Group__*'
  event << '(upon saying "CBA prefix") reminds you the prefix'
  event << '`A^info`: Shows you some info about CB, or something'
  event << '`A^rnumber <Number> <Other Number>`: Gives you a random number'
  event << '`A^help`: Basically tells you to go here'
  event << '`A^cmds`: pulls up this'
  event << '`A^eightball`: Ask the 8ball something'
  event << '`A^userinfo`: Shows some info about you'
  event << '`A^reverse`: Reverses text'
  event << '`A^flip`: Flips a coin, what else did you expect?'
  event << '`A^flop`: Flops a coin, what expect did you else?'
  event << '`A^ping`: Used to show response time'
  event << '`A^servercount`: Returns the number of servers CB is in'
  event << '`A^invite`: Gives you a link to invite me to your own server!'
  event << '`A^roll`: Rolls a number between 1 and 6'
  event << '`A^donate`: Want to donate? That\'s great! This command gives you a link for Patreon donations'
  event << '`A^update`: Gives you the latest CB update'
  event << '`A^feedback <words>`: Sends your feedback to the CB Server'
  event << '`A^thanks`: Thanks to these radical donors!'
  event << '`A^trello`: The Trello board, woahdude'
  event << '`A^noot`: noot (don\'t ask I didn\'t write this)'
  event << ''
  event << 'As always, if you find a horrible bug, report it in the CB Server <https://cah.soarn.pro/server-invite>'
end

bot.command(:feedback, min_args: 1) do |event, *args|
  if event.channel.pm? == true
    bot.send_message(252_239_053_712_392_192, "New Feedback from `#{event.user.name}`\##{event.user.discriminator}. ID: #{event.user.id}. From a DM.

*#{args.join(' ')}*")
    m = (event.respond 'Radical! Feedback sent.')
    sleep 5
    m.delete
  else
    event.message.delete
    bot.send_message(252_239_053_712_392_192, "New Feedback from `#{event.user.name}`\##{event.user.discriminator}. ID: #{event.user.id}. From the land of `#{event.server.name}` (Server ID: #{event.server.id}).
*#{args.join(' ')}*")
    m = (event.respond 'Radical! Feedback sent.')
    sleep 5
    m.delete
  end
end

bot.run :async

bot.sync
