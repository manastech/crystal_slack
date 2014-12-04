### crystal_slack

Parse Slack slash commands or send incoming web hooks from Crystal.

#### Projectfile

```crystal
deps do
  github "manastech/crystal_slack"
end
```

#### Usage

You can get a Slack::SlashCommand from an HTTP::Request or its body:

```crystal
require "slack"

request = HTTP::Request.new "POST", "/", body: "token=..."
command = Slack::SlashCommand.from_request(request)
puts command.text
```

You can create an incoming web hook and send it:

```crystal
require "slack"

hook = Slack::IncomingWebHook.new("some_text", channel: "some_channel")
hook.send_to "https://hooks.slack.com/services/..."
```
