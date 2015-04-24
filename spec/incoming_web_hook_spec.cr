require "./spec_helper"

describe Slack::IncomingWebHook do
  it "initializes from json and types send_to" do
    WebMock.wrap do
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

      WebMock.stub(:post, "slack.com/").
           with(body: "payload=%7B%22text%22%3A%22some_text%22%2C%22channel%22%3A%22some_channel%22%2C%22icon_emoji%22%3A%22some_emoji%22%2C%22icon_url%22%3A%22some_url%22%2C%22username%22%3A%22some_username%22%7D", headers: {"Content-type" => "application/x-www-form-urlencoded"})

      hook.send_to("http://slack.com")
    end
  end
end
