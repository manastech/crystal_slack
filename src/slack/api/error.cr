class Slack::API::Error < Exception
  def initialize(response : HTTP::Client::Response)
    super("Slack::API::Error: #{response.status_code}\n#{response.body}")
  end

  def initialize(message)
    super(message)
  end
end
