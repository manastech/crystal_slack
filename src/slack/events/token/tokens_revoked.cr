class Slack::Events::Token::TokensRevoked < Slack::Event
  property tokens : JSON::Any

  @[JSON::Field(converter: Slack::DecimalTimeStampConverter)]
  property event_ts : Time
end
