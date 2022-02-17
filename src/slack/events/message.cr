class Slack::Events::Message < Slack::Event
  use_optional_discriminator "subtype", {
    bot_add:         Slack::Events::Message::BotAdd,
    channel_join:    Slack::Events::Message::ChannelJoin,
    message_changed: Slack::Events::Message::MessageChanged,
    message_deleted: Slack::Events::Message::MessageDeleted,
  }

  property attachments : Array(Attachment)?,
    blocks : Array(JSON::Any),
    channel_type : String?,
    team : String?,
    text : String,
    ts : String?
end
