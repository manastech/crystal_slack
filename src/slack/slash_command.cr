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
    params = HTTP::Params.parse(body)
    SlashCommand.new(
      params["token"],
      params["team_id"],
      params["channel_id"],
      params["channel_name"],
      params["user_id"],
      params["user_name"],
      params["command"],
      params["text"],
    )
  end

  def initialize(@token : String, @team_id : String, @channel_id : String,
                 @channel_name : String, @user_id : String, @user_name : String,
                 @command : String, @text : String)
  end
end
