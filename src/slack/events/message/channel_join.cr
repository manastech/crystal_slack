class Slack::Events::Message::ChannelJoin < Slack::Event
  property channel : String,
    channel_type : String,
    inviter : String,
    subtype : String,
    text : String

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property event_ts : Time

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property ts : Time
end
