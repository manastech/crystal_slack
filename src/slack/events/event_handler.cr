class Slack::Events::EventHandler
  @request : Webhooks::VerifiedRequest
  delegate event, to: @event_payload

  getter request, event_payload

  def initialize(request : HTTP::Request)
    @request = verify_slack_request(request)
    @event_payload = EventPayload.from_json(@request.body.to_s)
  end

  private def verify_slack_request(slack_request) : Webhooks::VerifiedRequest
    Webhooks::VerifiedRequest.new(request: slack_request).verify!
  end
end
