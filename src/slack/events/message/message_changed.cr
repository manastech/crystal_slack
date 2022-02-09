class Slack::Events::Message::MessageChanged < Slack::Event
  property channel : String,
    channel_type : String,
    event_ts : String,
    hidden : Bool,
    previous_message : Message,
    subtype : String,
    ts : String,
    message : Message
end
