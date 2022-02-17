class Slack::Events::App::AppHomeOpened < Slack::Event
  property channel : String,
    event_ts : String,
    tab : String,
    user : String
end
