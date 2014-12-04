require "cgi"
require "http/request"

class Slack::SlashCommand
  getter token
  getter team_id
  getter channel_id
  getter channel_name
  getter user_id
  getter user_name
  getter command
  getter text

  def self.from_request(request : HTTP::Request)
    from_request_body request.body.not_nil!
  end

  def self.from_request_body(body)
    hash = CGI.parse(body)
    SlashCommand.new(
      hash["token"].first,
      hash["team_id"].first,
      hash["channel_id"].first,
      hash["channel_name"].first,
      hash["user_id"].first,
      hash["user_name"].first,
      hash["command"].first,
      hash["text"].first,
      )
  end

  def initialize(@token, @team_id, @channel_id, @channel_name, @user_id, @user_name, @command, @text)
  end
end
