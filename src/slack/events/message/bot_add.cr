class Slack::Events::Message::BotAdd < Slack::Event
  property bot_id : String,
    bot_link : String,
    channel : String,
    channel_type : String,
    subtype : String,
    text : String,
    user : String

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property event_ts : Time

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property ts : Time
end
