struct Slack::Events::EventPayload
  include JSON::Serializable

  property api_app_id : String,
    authorizations : Array(JSON::Any)?,
    event : Slack::Event,
    event_context : String?,
    event_id : String,
    team_id : String,
    token : String,
    type : String

  @[JSON::Field(converter: Time::EpochConverter)]
  property event_time : Time
end
