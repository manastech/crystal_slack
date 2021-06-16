class Slack::API::User
  include JSON::Serializable

  property id : String
  property name : String
  property deleted : Bool
  property color : String?
  property profile : Profile
  property is_admin : Bool?
  property is_owner : Bool?
  property is_primary_owner : Bool?
  property is_restricted : Bool?
  property is_ultra_restricted : Bool?
  property has_2fa : Bool?
  property has_files : Bool?

  def initialize(@id : String, @name : String, @deleted : Bool, @profile : Profile)
  end

  class Profile
    include JSON::Serializable

    property first_name : String?
    property last_name : String?
    property real_name : String
    property email : String?
    property skype : String?
    property phone : String?
    property image_24 : String?
    property image_32 : String?
    property image_48 : String?
    property image_72 : String?
    property image_192 : String?

    def initialize(@real_name : String, @email : String? = nil)
    end
  end
end
