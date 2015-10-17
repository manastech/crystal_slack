require "json"
require "uri"
require "http/client"

class Slack::IncomingWebHook
  JSON.mapping({
    text:       String,
    channel:    {type: String, nilable: true},
    icon_emoji: {type: String, nilable: true},
    icon_url:   {type: String, nilable: true},
    username:   {type: String, nilable: true},
  })

  def initialize(@text : String, @channel = nil, @icon_emoji = nil, @icon_url = nil, @username = nil)
  end

  def send_to(url)
    HTTP::Client.post_form url, "payload=#{URI.escape to_json}"
  end
end
