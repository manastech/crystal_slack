require "spec"
require "../src/slack"

describe Slack::IncomingWebHook do
  it "initializes from json and types send_to" do
    hook = Slack::IncomingWebHook.from_json(%({
      "text": "some_text",
      "channel": "some_channel",
      "icon_emoji": "some_emoji",
      "icon_url": "some_url",
      "username": "some_username"
      }))
    hook.text.should eq("some_text")
    hook.channel.should eq("some_channel")
    hook.icon_emoji.should eq("some_emoji")
    hook.icon_url.should eq("some_url")
    hook.username.should eq("some_username")

    typeof(hook.send_to("some_url"))
  end
end
