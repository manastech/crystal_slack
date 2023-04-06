require "./spec_helper"

describe Slack::API do
  describe "oauth session" do
    it "authenticates" do
      oauth_client = OAuth2::Client.new("slack.com", "key", "secret")
      oauth_token = OAuth2::AccessToken::Bearer.new("oauth2_token", expires_in: 1.hour.from_now.to_unix.to_i64)
      oauth_session = OAuth2::Session.new(oauth_client, oauth_token, expires_at: 1.hour.from_now) {}

      stub = WebMock
        .stub(:get, "https://slack.com/api/users.list?")
        .with(headers: { "Authorization" => "Bearer oauth2_token" })
        .to_return(body: { "ok" => true, "members" => [] of Slack::API::User }.to_json)

      api = Slack::API.new(oauth_session)
      api.users

      stub.calls.should eq(1)
    end
  end

  it "gets users" do
    api = Slack::API.new "some_token"

    data = {
      "id" => "U023BECGF",
      "name" => "bobby",
      "deleted" => false,
      "color" => "9f69e7",
      "profile" => {
        "first_name" => "Bobby",
        "last_name" => "Tables",
        "real_name" => "Bobby Tables",
        "email" => "bobby@slack.com",
        "skype" => "my-skype-name",
        "phone" => "+1 (123) 456 7890",
        "image_24" => "image_24_1",
        "image_32" => "image_32_1",
        "image_48" => "image_48_1",
        "image_72" => "image_72_1",
        "image_192" => "image_192_1"
      },
      "is_admin" => true,
      "is_owner" => true,
      "has_2fa" => false,
      "has_files" => true
    }

    WebMock
      .stub(:get, "https://slack.com/api/users.list?")
      .with(headers: { "Authorization" => "Bearer some_token" })
      .to_return(body: { "ok" => true, "members" => [data] }.to_json)

    users = api.users
    users.size.should eq(1)

    user = users[0]
    JSON.parse(user.to_json).should eq(data)
  end

  it "gets channels" do
    api = Slack::API.new "some_token"

    data = {
      "id" => "C012AB3CD",
      "name" => "general",
      "is_channel" => true,
      "is_group" => false,
      "is_im" => false,
      "created" => 1449252889,
      "creator" => "U012A3CDE",
      "is_archived" => false,
      "is_general" => true,
      "unlinked" => 0,
      "name_normalized" => "general",
      "is_shared" => false,
      "is_ext_shared" => false,
      "is_org_shared" => false,
      "pending_shared" => [] of String,
      "is_pending_ext_shared" => false,
      "is_member" => true,
      "is_private" => false,
      "is_mpim" => false,
      "topic" => {
        "value" => "Company-wide announcements and work-based matters",
        "creator" => "",
        "last_set" => 0
      },
      "purpose" => {
        "value" => "This channel is for team-wide communication and announcements. All team members are in this channel.",
        "creator" => "",
        "last_set" => 0
      },
      "previous_names" => [] of String,
      "num_members" => 4
    }

    relevant_fields = {
      "id" => "C012AB3CD",
      "name" => "general",
      "created" => 1449252889,
      "creator" => "U012A3CDE",
      "is_archived" => false,
      "is_member" => true,
      "num_members" => 4,
      "topic" => {
        "value" => "Company-wide announcements and work-based matters",
        "creator" => "",
        "last_set" => 0
      },
      "purpose" => {
        "value" => "This channel is for team-wide communication and announcements. All team members are in this channel.",
        "creator" => "",
        "last_set" => 0
      }
    }

    WebMock
      .stub(:get, "https://slack.com/api/conversations.list?")
      .with(headers: { "Authorization" => "Bearer some_token" })
      .to_return(body: {
        "ok" => true,
        "channels" => [data],
        "response_metadata" => {
          "next_cursor" => "dGVhbTpDMDYxRkE1UEI="
        }
      }.to_json)

    channels = api.channels
    channels.size.should eq(1)

    channel = channels[0]
    JSON.parse(channel.to_json).should eq(relevant_fields)
  end

  it "gets a channel's details" do
    api = Slack::API.new "some_token"

    data = {
      "id" => "C012AB3CD",
      "name" => "general",
      "is_channel" => true,
      "is_group" => false,
      "is_im" => false,
      "created" => 1449252889,
      "creator" => "W012A3BCD",
      "is_archived" => false,
      "is_general" => true,
      "unlinked" => 0,
      "name_normalized" => "general",
      "is_read_only" => false,
      "is_shared" => false,
      "parent_conversation" => nil,
      "is_ext_shared" => false,
      "is_org_shared" => false,
      "pending_shared" => [] of String,
      "is_pending_ext_shared" => false,
      "is_member" => true,
      "is_private" => false,
      "is_mpim" => false,
      "last_read" => "1502126650.228446",
      "topic" => {
        "value" => "For public discussion of generalities",
        "creator" => "W012A3BCD",
        "last_set" => 1449709364
      },
      "purpose" => {
        "value" => "This part of the workspace is for fun. Make fun here.",
        "creator" => "W012A3BCD",
        "last_set" => 1449709364
      },
      "previous_names" => [
        "specifics",
        "abstractions",
        "etc"
      ],
      "locale" => "en-US"
    }

    relevant_fields = {
      "id" => "C012AB3CD",
      "name" => "general",
      "created" => 1449252889,
      "creator" => "W012A3BCD",
      "is_archived" => false,
      "is_member" => true,
      "topic" => {
        "value" => "For public discussion of generalities",
        "creator" => "W012A3BCD",
        "last_set" => 1449709364
      },
      "purpose" => {
        "value" => "This part of the workspace is for fun. Make fun here.",
        "creator" => "W012A3BCD",
        "last_set" => 1449709364
      }
    }

    WebMock
      .stub(:get, "https://slack.com/api/conversations.info?channel=C012AB3CD")
      .with(headers: { "Authorization" => "Bearer some_token" })
      .to_return(body: { "ok" => true, "channel" => data }.to_json)

    channel = api.channel_info("C012AB3CD")

    JSON.parse(channel.to_json).should eq(relevant_fields)
  end

  it "posts to a channel" do
    api = Slack::API.new "some_token"

    data = {
      "ok" => true,
      "channel" => "C1PJMB3MI",
      "ts" => "1468419247.000010",
      "message" => {
        "text" => "something important",
        "username" => "the bot",
        "bot_id" => "B1R4VQ5RU",
        "type" => "message",
        "subtype" => "bot_message",
        "ts" => "1468419247.000010"
      }
    }

    stub = WebMock
      .stub(:post, "https://slack.com/api/chat.postMessage?text=something+important&channel=general")
      .with(headers: { "Authorization" => "Bearer some_token" })
      .to_return(body: data.to_json)

    api.post_message(text: "something important", channel: "general")

    stub.calls.should eq(1)
  end

  it "raises if posting to a channel failed" do
    api = Slack::API.new "some_token"

    stub = WebMock
      .stub(:post, "https://slack.com/api/chat.postMessage?text=something+important&channel=general")
      .with(headers: { "Authorization" => "Bearer some_token" })
      .to_return(status: 400)

    expect_raises(Slack::API::Error) do
      api.post_message(text: "something important", channel: "general")
    end

    stub.calls.should eq(1)
  end
end
