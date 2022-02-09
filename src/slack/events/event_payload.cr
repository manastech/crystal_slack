struct Slack::Events::EventPayload
  include JSON::Serializable

  property api_app_id : String,
    authorizations : Array(JSON::Any)?,
    event : Slack::Event,
    event_context : String?,
    event_id : String,
    event_time : Int64,
    team_id : String,
    token : String,
    type : String
end
