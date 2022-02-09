class Slack::Events::Reaction::ReactionRemoved < Slack::Event
  property event_ts : String,
    item : JSON::Any,
    item_user : String,
    reaction : String,
    user : String
end
