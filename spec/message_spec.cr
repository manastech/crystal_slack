require "./spec_helper"

describe Slack::Message do
  it "initializes from json and types send_to" do
    message = Slack::Message.from_json(%({
      "text": "some_text",
      "channel": "some_channel",
      "icon_emoji": "some_emoji",
      "icon_url": "some_url",
      "username": "some_username"
      }))
    message.text.should eq("some_text")
    message.channel.should eq("some_channel")
    message.icon_emoji.should eq("some_emoji")
    message.icon_url.should eq("some_url")
    message.username.should eq("some_username")

    stub = WebMock.stub(:post, "slack.com/")
                  .with(body: "payload=%7B%22text%22%3A%22some_text%22%2C%22channel%22%3A%22some_channel%22%2C%22icon_emoji%22%3A%22some_emoji%22%2C%22icon_url%22%3A%22some_url%22%2C%22username%22%3A%22some_username%22%7D", headers: {"Content-type" => "application/x-www-form-urlencoded"})

    message.send_to_hook("http://slack.com")
    stub.calls.should eq(1)
  end

  it "supports arbitrary json for attachments" do
    message = Slack::Message.from_json(%({
      "text": "some_text",
      "channel": "some_channel",
      "username": "some_username",
      "attachments": [
        { "foo": "bar", "baz": 123 },
        { "something" : ["else"] }
      ]
      }))

    message.text.should eq("some_text")
    message.channel.should eq("some_channel")
    message.username.should eq("some_username")
    message.attachments.not_nil!.size.should eq(2)

    stub = WebMock.stub(:post, "slack.com/")
                  .with(body: "payload=%7B%22text%22%3A%22some_text%22%2C%22channel%22%3A%22some_channel%22%2C%22username%22%3A%22some_username%22%2C%22attachments%22%3A%5B%7B%22foo%22%3A%22bar%22%2C%22baz%22%3A123%7D%2C%7B%22something%22%3A%5B%22else%22%5D%7D%5D%7D", headers: {"Content-type" => "application/x-www-form-urlencoded"})

    message.send_to_hook("http://slack.com")
    stub.calls.should eq(1)
  end
end
