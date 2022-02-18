class Slack::Events::Message::MessageDeleted < Slack::Event
  property channel : String,
    channel_type : String,
    hidden : Bool,
    previous_message : Message,
    subtype : String

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property event_ts : Time

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property ts : Time
end
