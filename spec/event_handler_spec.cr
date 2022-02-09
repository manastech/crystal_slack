require "./spec_helper"

def build_http_request(headers, body)
  HTTP::Request.new(
    "POST",
    "/webhook_url",
    headers: headers,
    body: body
  )
end

def build_request(namespace, name)
  headers, event = request_data(namespace, name)
  build_http_request(headers, event)
end

def build_request(namespace)
  headers, event = request_data(namespace)
  build_http_request(headers, event)
end

def load_event(event_namespace, name)
  File.read("spec/fixtures/events/#{event_namespace}/#{name}.json")
end

def load_event(name)
  File.read("spec/fixtures/events/#{name}.json")
end

def request_data(event_namespace, name) : Tuple(HTTP::Headers, String)
  headers = HTTP::Headers.new
  timestamp = 1.minutes.ago.to_unix.to_s
  event = load_event(event_namespace, name)
  signature = Slack::Webhooks::Signature.new(timestamp, event).compute
  headers["X-Slack-Request-Timestamp"] = timestamp
  headers["X-Slack-Signature"] = signature
  {headers, event}
end

def request_data(event_namespace)
  headers = HTTP::Headers.new
  timestamp = 1.minutes.ago.to_unix.to_s
  event = load_event(event_namespace)
  signature = Slack::Webhooks::Signature.new(timestamp, event).compute
  headers["X-Slack-Request-Timestamp"] = timestamp
  headers["X-Slack-Signature"] = signature
  {headers, event}
end

describe Slack::Events::EventHandler do
  context "replay attack attempt" do
    it "prevents replay attacks" do
      headers = HTTP::Headers.new
      headers["X-Slack-Request-Timestamp"] = 10.minutes.ago.to_unix.to_s
      headers["X-Slack-Signature"] = "signature"
      event = load_event("message")
      request = HTTP::Request.new(
        "POST",
        "/webhook_url",
        headers: headers,
        body: event
      )

      expect_raises(Slack::Webhooks::VerifiedRequest::ReplayAttackError) do
        Slack::Events::EventHandler.new(request)
      end
    end
  end

  context "unverified events" do
    it "does not process unverified events" do
      headers = HTTP::Headers.new
      timestamp = 1.minutes.ago.to_unix.to_s
      event = load_event("message", "message_changed")
      signature = "signaturewillnotmatch"
      headers["X-Slack-Request-Timestamp"] = timestamp
      headers["X-Slack-Signature"] = signature

      request = HTTP::Request.new(
        "POST",
        "/webhook_url",
        headers: headers,
        body: event
      )

      expect_raises(Slack::Webhooks::VerifiedRequest::SignatureMismatchError) do
        Slack::Events::EventHandler.new(request)
      end
    end
  end

  context "message events" do
    it "handles message_deleted events" do
      request = build_request("message", "message_deleted")
      event = pp Slack::Events::EventHandler.new(request).event
      puts "\n"
      # message.is_a?(Slack::Events::Message).should be_true
      # message.attachments.should_not be_empty
    end

    it "handles message_changed events" do
      request = build_request("message", "message_changed")
      event = pp Slack::Events::EventHandler.new(request).event
      puts "\n"
      # message.is_a?(Slack::Events::Message).should be_true
      # message.attachments.should_not be_empty
    end

    it "handles new message events" do
      request = build_request("message")
      event = pp Slack::Events::EventHandler.new(request).event
      puts "\n"
      # message.is_a?(Slack::Events::Message).should be_true
      # message.attachments.should be_empty
      # message.text.should eq <<-LINK
      # <https://rubytocrystal.substack.com/p/the-short-road-to-lucky-with-crystal>
      # LINK
    end

    it "handles bot add events" do
      request = build_request("message", "bot_add")
      event = pp Slack::Events::EventHandler.new(request).event
      puts "\n"
    end

    it "handles channel join events" do
      request = build_request("message", "channel_join")
      event = pp Slack::Events::EventHandler.new(request).event
      puts "\n"
    end
  end

  context "app events" do
    it "should handle uninstalled events" do
      request = build_request("app", "app_uninstalled")
      event = pp Slack::Events::EventHandler.new(request).event_payload
      puts "\n"
    end
  end

  context "token events" do
    it "should handle revoked events" do
      request = build_request("tokens", "tokens_revoked")
      event = pp Slack::Events::EventHandler.new(request).event_payload
      puts "\n"
    end
  end

  context "reaction events" do
    it "should handle removed events" do
      request = build_request("reaction", "reaction_removed")
      event = pp Slack::Events::EventHandler.new(request).event_payload
      puts "\n"
    end

    it "should handle added events" do
      request = build_request("reaction", "reaction_added")
      event = pp Slack::Events::EventHandler.new(request).event_payload
      puts "\n"
    end
  end
end
