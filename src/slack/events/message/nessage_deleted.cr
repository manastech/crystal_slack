class Slack::Events::Message::MessageDeleted < Slack::Event
  property channel : String,
    channel_type : String,
    event_ts : String,
    hidden : Bool,
    previous_message : Message,
    subtype : String,
    ts : String
end
