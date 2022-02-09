class Slack::Events::Token::TokensRevoked < Slack::Event
  property tokens : JSON::Any,
    event_ts : String
end
