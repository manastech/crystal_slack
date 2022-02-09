require "openssl/hmac"

class Slack::Webhooks::Signature
  delegate signing_secret, to: Slack::Config.settings
  delegate signing_secret_version, to: Slack::Config.settings

  def initialize(@slack_timestamp : String, @body : String)
  end

  def basestring : String
    [signing_secret_version, @slack_timestamp, @body].join(":")
  end

  def compute
    hex_hash = OpenSSL::HMAC.hexdigest(:sha256, signing_secret, basestring)
    [signing_secret_version, hex_hash].join("=")
  end
end
