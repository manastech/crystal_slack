module Slack::DecimalTimeStampConverter
  def self.from_json(value : JSON::PullParser) : Time
    Time.parse!(value.read_string, "%s.%6N")
  end
end
