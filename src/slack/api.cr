class Slack::API
  def initialize(@token : String)
    @client = HTTP::Client.new "slack.com", tls: true
  end

  def users
    get_json "/api/users.list", "members", Array(User)
  end

  def channels
    get_json "/api/channels.list", "channels", Array(Channel)
  end

  def post_message(channel, text)
    post "/api/chat.postMessage", channel: channel, text: text
  end

  private def get_json(url, field, klass)
    response = @client.get "#{url}?token=#{@token}"
    handle(response) do
      parse_response response.body, field, klass
    end
  end

  private def parse_response(body, field, klass)
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

  private def post(url, **params)
    params = HTTP::Params.build do |form|
      form.add "token", @token

      params.each do |k,v|
        form.add k.to_s, v
      end
    end

    response = @client.post "#{url}?#{params}"
    handle(response) {}
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
