struct Slack::Events::Attachment
  include JSON::Serializable

  property id : Int16,
    original_url : String,
    service_icon : String,
    service_name : String,
    text : String,
    title : String,
    title_link : String,
    fallback : String
end
