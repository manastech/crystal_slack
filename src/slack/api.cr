require "oauth2"

class Slack::API
  @token : String?
  @oauth_session : OAuth2::Session?
  @mutex = Mutex.new

  class_property slack_host : String = "slack.com"

  def initialize(@token : String)
    @client = HTTP::Client.new self.class.slack_host, tls: true
  end

  def initialize(@oauth_session : OAuth2::Session)
    @client = HTTP::Client.new self.class.slack_host, tls: true
  end

  def users
    get_json "/api/users.list", "members", Array(User)
  end

  def channels
    get_json "/api/conversations.list", "channels", Array(Channel)
  end

  def channel_info(channel_id)
    get_json "/api/conversations.info", "channel", Channel, {"channel" => channel_id}
  end

  def post_message(text : String, channel : String)
    post_message(Message.new(text: text, channel: channel))
  end

  def post_message(message : Message)
    params = HTTP::Params.build do |form|
      message.add_params(form)
    end

    post_json "/api/chat.postMessage?#{params}"
  end

  def update_message(message : Message, timestamp : String)
    encoded_params = HTTP::Params.build do |form|
      form.add "ts", timestamp
      message.add_params(form)
    end

    post_json "/api/chat.update?#{encoded_params}"
  end

  private def get_json(url, field, klass, params = {} of String => String)
    encoded_params = HTTP::Params.build do |form|
      params.each do |(k, v)|
        form.add k, v
      end
    end

    response = @mutex.synchronize do
      @oauth_session.try(&.authenticate(@client))
      @client.get("#{url}?#{encoded_params}", headers: authenticated_headers)
    end

    handle(response) do
      parse_response_object response.body, field, klass
    end
  end

  private def parse_response_object(body, field, klass)
    error = nil

    pull = JSON::PullParser.new(body)
    pull.read_object do |key|
      case key
      when "ok"
        pull.read_bool
      when "error"
        error = pull.read_string
      when field
        return klass.new(pull)
      else
        pull.skip
      end
    end

    raise Error.new(error.not_nil!)
  end

  private def post_json(url)
    # the post message API doesn't support json paylods
    # we send each field as a separate URL param
    response = @mutex.synchronize do
      @oauth_session.try(&.authenticate(@client))
      @client.post(url, headers: authenticated_headers)
    end

    handle(response) do
      parse_post_response(response.body)
    end
  end

  private def authenticated_headers
    if token = @token
      HTTP::Headers{"Authorization" => "Bearer #{token}"}
    end
  end

  private def parse_post_response(body)
    error = nil
    ts = nil
    channel = nil

    pull = JSON::PullParser.new(body)
    pull.read_object do |key|
      case key
      when "ok"
        pull.read_bool
      when "error"
        error = pull.read_string
      when "ts"
        ts = pull.read_string
      when "channel"
        channel = pull.read_string
      else
        pull.skip
      end
    end

    if ts && channel
      {timestamp: ts.not_nil!, channel: channel.not_nil!}
    else
      raise Error.new(error.not_nil!)
    end
  end

  private def handle(response)
    case response.status_code
    when 200, 201
      yield
    else
      raise Error.new(response)
    end
  end
end
