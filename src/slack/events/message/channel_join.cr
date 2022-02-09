class Slack::Events::Message::ChannelJoin < Slack::Event
  property channel : String,
    channel_type : String,
    event_ts : String,
    inviter : String,
    subtype : String,
    text : String,
    ts : String
end
