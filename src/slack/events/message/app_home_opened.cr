class Slack::Events::App::AppHomeOpened < Slack::Event
  property channel : String,
    tab : String,
    user : String
end
