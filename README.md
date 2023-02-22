# crystal_slack

[![Build Status](https://travis-ci.org/manastech/crystal_slack.svg?branch=master)](https://travis-ci.org/manastech/crystal_slack)

Access [Slack API's](https://api.slack.com/) using [Crystal](http://crystal-lang.org).

## Shards

```yaml
slack:
  github: "manastech/crystal_slack"
```

## Usage

You can get a Slack::SlashCommand from an HTTP::Request or its body:

```crystal
require "slack"

request = HTTP::Request.new "POST", "/", body: "token=..."
command = Slack::SlashCommand.from_request(request)
puts command.text
```

You can create a message and send it using either webhooks or the `chat.postMessage` API:

```crystal
require "slack"

message = Slack::Message.new("some_text", channel: "some_channel")

# send to webhook
message.send_to_hook "https://hooks.slack.com/services/..."

# send using the chat.postMessage API
api = Slack::API.new "some_token"
api.post_message(message)
```

More complex messages are supported. Please check the Message class.
You can also get the users and channels given an token.


If you wish to configure the upstream slack host, you may do so

```crystal
require "slack"

Slack::API.slack_host = "enterprise.slack.com" # Defaults to "slack.com"
```

## Todo

Lots of API methods are missing!

## Contributing

1. Fork it ( https://github.com/manastech/crystal_slack/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
