# crystal_slack

Access [Slack API's](https://api.slack.com/) using [Crystal](http://crystal-lang.org).

## Projectfile

```crystal
deps do
  github "manastech/crystal_slack"
end
```

## Usage

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

You can also get the users and channels given an token.

## Todo

Lots of API methods are missing!

## Contributing

1. Fork it ( https://github.com/manastech/crystal_slack/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
