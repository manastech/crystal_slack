require "./serializable_event.cr"

abstract class Slack::Event
  include JSON::Serializable
  include Slack::SerializableEvent

  property type : String

  use_json_discriminator "type", {
    app_home_opened:  Slack::Events::App::AppHomeOpened,
    app_uninstalled:  Slack::Events::App::AppUninstalled,
    message:          Slack::Events::Message,
    reaction_added:   Slack::Events::Reaction::ReactionAdded,
    reaction_removed: Slack::Events::Reaction::ReactionRemoved,
    tokens_revoked:   Slack::Events::Token::TokensRevoked,
  }
end
