class Slack::API::Channel
  include JSON::Serializable

  property id : String
  property name : String
  property created : Int64
  property creator : String
  property is_archived : Bool
  property is_member : Bool
  property num_members : Int32?
  property topic : Topic
  property purpose : Topic

  struct Topic
    include JSON::Serializable

    property value : String
    property creator : String
    property last_set : Int64
  end
end
