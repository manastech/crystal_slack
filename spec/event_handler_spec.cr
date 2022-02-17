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

def build_headers_and_body(body)
  headers = HTTP::Headers.new
  timestamp = 1.minutes.ago.to_unix.to_s
  signature = Slack::Webhooks::Signature.new(timestamp, body).compute
  headers["X-Slack-Request-Timestamp"] = timestamp
  headers["X-Slack-Signature"] = signature
  {headers, body}
end

def request_data(event_namespace, name) : Tuple(HTTP::Headers, String)
  event = load_event(event_namespace, name)
  build_headers_and_body(event)
end

def request_data(event_namespace) : Tuple(HTTP::Headers, String)
  event = load_event(event_namespace)
  build_headers_and_body(event)
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
      event = Slack::Events::EventHandler.new(request).event
      event.is_a?(Slack::Events::Message::MessageDeleted).should be_true
    end

    it "handles message_changed events" do
      request = build_request("message", "message_changed")
      event = Slack::Events::EventHandler.new(request).event
      event.is_a?(Slack::Events::Message::MessageChanged).should be_true
    end

    it "handles new message events" do
      request = build_request("message")
      event = Slack::Events::EventHandler
        .new(request)
        .event
        .as(Slack::Events::Message)

      event.text.should eq <<-LINK
      <https://rubytocrystal.substack.com/p/the-short-road-to-lucky-with-crystal>
      LINK
    end

    it "handles message requests from bots" do
      request = build_request("bot_message")
      event = Slack::Events::EventHandler
        .new(request)
        .event
        .as(Slack::Events::Message)

      event.text.should eq "But what about my friend the bot"
    end

    it "handles bot add events" do
      request = build_request("message", "bot_add")
      event = Slack::Events::EventHandler.new(request).event
      event.is_a?(Slack::Events::Message::BotAdd).should be_true
    end

    it "handles channel join events" do
      request = build_request("message", "channel_join")
      event = Slack::Events::EventHandler.new(request).event
      event.is_a?(Slack::Events::Message::ChannelJoin).should be_true
    end
  end

  context "app events" do
    it "should handle uninstalled events" do
      request = build_request("app", "app_uninstalled")
      event = Slack::Events::EventHandler.new(request).event
      event.is_a?(Slack::Events::App::AppUninstalled).should be_true
    end

    it "should handle home_opened events" do
      request = build_request("app", "app_home_opened")

      event = Slack::Events::EventHandler
        .new(request)
        .event
        .as(Slack::Events::App::AppHomeOpened)

      event.tab.should eq "home"
      event.type.should eq "app_home_opened"
    end
  end

  context "token events" do
    it "should handle revoked events" do
      request = build_request("tokens", "tokens_revoked")
      event = Slack::Events::EventHandler.new(request).event
      event.is_a?(Slack::Events::Token::TokensRevoked).should be_true
    end
  end

  context "reaction events" do
    it "should handle removed events" do
      request = build_request("reaction", "reaction_removed")
      event = Slack::Events::EventHandler.new(request).event
    end

    it "should handle added events" do
      request = build_request("reaction", "reaction_added")
      event = Slack::Events::EventHandler.new(request).event
    end
  end
end
