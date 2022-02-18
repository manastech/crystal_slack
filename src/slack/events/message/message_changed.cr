class Slack::Events::Message::MessageChanged < Slack::Event
  property channel : String,
    channel_type : String,
    hidden : Bool,
    previous_message : Message,
    subtype : String,
    message : Message

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property event_ts : Time

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property ts : Time
end
