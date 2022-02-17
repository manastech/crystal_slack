class Slack::Events::Message::BotAdd < Slack::Event
  property bot_id : String,
    bot_link : String,
    channel : String,
    channel_type : String,
    event_ts : String,
    subtype : String,
    text : String,
    user : String,
    ts : String
end
