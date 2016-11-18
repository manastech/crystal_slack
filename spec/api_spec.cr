require "./spec_helper"

describe Slack::API do
  it "gets users" do
    api = Slack::API.new "some_token"

    json = %({
                "id": "U023BECGF",
                "name": "bobby",
                "deleted": false,
                "color": "9f69e7",
                "profile": {
                    "first_name": "Bobby",
                    "last_name": "Tables",
                    "real_name": "Bobby Tables",
                    "email": "bobby@slack.com",
                    "skype": "my-skype-name",
                    "phone": "+1 (123) 456 7890",
                    "image_24": "image_24_1",
                    "image_32": "image_32_1",
                    "image_48": "image_48_1",
                    "image_72": "image_72_1",
                    "image_192": "image_192_1"
                },
                "is_admin": true,
                "is_owner": true,
                "has_2fa": false,
                "has_files": true
            })

    WebMock.stub(:get, "https://slack.com/api/users.list?token=some_token")
           .to_return(body: %({
          "ok": true,
          "members": [#{json}]
        }))

    users = api.users
    users.size.should eq(1)

    user = users[0]
    JSON.parse(user.to_json).should eq(JSON.parse(json))
  end

  it "gets channels" do
    api = Slack::API.new "some_token"

    json = %({
                "id": "C024BE91L",
                "name": "fun",
                "created": 1360782804,
                "creator": "U024BE7LH",
                "is_archived": false,
                "is_member": false,
                "num_members": 6,
                "topic": {
                    "value": "Fun times",
                    "creator": "U024BE7LV",
                    "last_set": 1369677212
                },
                "purpose": {
                    "value": "This channel is for fun",
                    "creator": "U024BE7LH",
                    "last_set": 1360782804
                }
            })

    WebMock.stub(:get, "https://slack.com/api/channels.list?token=some_token")
           .to_return(body: %({
          "ok": true,
          "channels": [#{json}]
        }))

    channels = api.channels
    channels.size.should eq(1)

    channel = channels[0]
    JSON.parse(channel.to_json).should eq(JSON.parse(json))
  end

  it "gets a channel's details" do
    api = Slack::API.new "some_token"

    json = %({
                "id": "C1RDH5HPE",
                "name": "fun",
                "created": 1360782804,
                "creator": "U024BE7LH",
                "is_archived": false,
                "is_member": false,
                "topic": {
                    "value": "Fun times",
                    "creator": "U024BE7LV",
                    "last_set": 1369677212
                },
                "purpose": {
                    "value": "This channel is for fun",
                    "creator": "U024BE7LH",
                    "last_set": 1360782804
                }
            })

    WebMock.stub(:get, "https://slack.com/api/channels.info?token=some_token&channel=C1RDH5HPE")
           .to_return(body: %({
          "ok": true,
          "channel": #{json}
        }))

    channel = api.channel_info("C1RDH5HPE")

    JSON.parse(channel.to_json).should eq(JSON.parse(json))
  end

  it "posts to a channel" do
    api = Slack::API.new "some_token"

    json = %({
      "ok": true,
      "channel": "C1PJMB3MI",
      "ts": "1468419247.000010",
      "message": {
        "text": "something important",
        "username": "the bot",
        "bot_id": "B1R4VQ5RU",
        "type": "message",
        "subtype": "bot_message",
        "ts": "1468419247.000010"
      }
    })

    stub = WebMock.stub(:post, "https://slack.com/api/chat.postMessage?token=some_token&text=something+important&channel=general")
                  .to_return(body: json)

    api.post_message(text: "something important", channel: "general")

    stub.calls.should eq(1)
  end

  it "raises if posting to a channel failed" do
    api = Slack::API.new "some_token"

    stub = WebMock.stub(:post, "https://slack.com/api/chat.postMessage?token=some_token&text=something+important&channel=general").to_return(status: 400)

    expect_raises(Slack::API::Error) do
      api.post_message(text: "something important", channel: "general")
    end

    stub.calls.should eq(1)
  end
end
