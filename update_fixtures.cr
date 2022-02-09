require "json"

def run(filename)
  filename = "spec/fixtures/events/#{filename}.json"
  data = File.read(filename)
  obj = JSON.parse(data)
  return if obj["data"]?.nil?

  File.write(filename, obj["data"].to_json)
end

%w(app/uninstalled bot/add channel/join message/deleted reaction/added
  reaction/removed tokens/revoked).each { |filename| run(filename) }
