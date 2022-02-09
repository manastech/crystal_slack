require "habitat"

module Slack
  class Config
    Habitat.create do
      setting signing_secret : String = ENV["SLACK_SIGNING_SECRET"]?.to_s
      setting signing_secret_version : String = "v0"
      setting webhook_delivery_time_limit : Time::Span = 5.minutes
    end
  end
end
