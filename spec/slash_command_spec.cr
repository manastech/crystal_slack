require "spec"
require "../src/slack"

describe Slack::SlashCommand do
  it "creates from HTTP::Request" do
    request = HTTP::Request.new "POST", "/",
      body: "token=some_token&team_id=0&channel_id=1&channel_name=some_channel&user_id=2&user_name=some_user&command=cmd&text=txt"

    command = Slack::SlashCommand.from_request(request)
    command.token.should eq("some_token")
    command.team_id.should eq("0")
    command.channel_id.should eq("1")
    command.channel_name.should eq("some_channel")
    command.user_id.should eq("2")
    command.user_name.should eq("some_user")
    command.command.should eq("cmd")
    command.text.should eq("txt")
  end

  it "creates from request body" do
    body = "token=some_token&team_id=0&channel_id=1&channel_name=some_channel&user_id=2&user_name=some_user&command=cmd&text=txt"

    command = Slack::SlashCommand.from_request_body(body)
    command.token.should eq("some_token")
    command.team_id.should eq("0")
    command.channel_id.should eq("1")
    command.channel_name.should eq("some_channel")
    command.user_id.should eq("2")
    command.user_name.should eq("some_user")
    command.command.should eq("cmd")
    command.text.should eq("txt")
  end
end
