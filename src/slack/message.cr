require "json"

class Slack::Message
  JSON.mapping({
    text:          String,
    channel:       {type: String, nilable: true},
    icon_emoji:    {type: String, nilable: true},
    icon_url:      {type: String, nilable: true},
    username:      {type: String, nilable: true},
    attachments:   {type: Array(JSON::Any), nilable: true},
    response_type: {type: String, nilable: true},
    delete_original:  {type: Bool, nilable: true},
    replace_original: {type: Bool, nilable: true},
  })

  def initialize(@text : String, @channel = nil, @icon_emoji = nil, @icon_url = nil, @username = nil, @attachments = nil, @response_type = nil, @delete_original = nil, @replace_original = nil)
  end

  def token=(token)
    @token = token
  end

  def send_to_hook(url)
    HTTP::Client.post_form url, "payload=#{URI.escape to_json}"
  end

  def post_with_api(api)
    api.post_message(self)
  end

  def add_params(form)
    form.add "text",           text
    form.add "channel",        channel             if channel
    form.add "icon_emoji",     icon_emoji          if icon_emoji
    form.add "icon_url",       icon_url            if icon_url
    form.add "username",       username            if username
    form.add "attachments",    attachments.to_json if attachments && !attachments.not_nil!.empty?

    form.add "response_type",  response_type       if response_type
    form.add "delete_original",  delete_original.to_s         if delete_original
    form.add "replace_original",  replace_original.to_s       if replace_original
  end
end
