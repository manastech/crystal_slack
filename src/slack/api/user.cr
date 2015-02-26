class Slack::API::User
  json_mapping({
    id: String,
    name: String,
    deleted: Bool,
    color: {type: String, nilable: true},
    profile: Profile,
    is_admin: {type: Bool, nilable: true},
    is_owner: {type: Bool, nilable: true},
    is_primary_owner: {type: Bool, nilable: true},
    is_restricted: {type: Bool, nilable: true},
    is_ultra_restricted: {type: Bool, nilable: true},
    has_files: {type: Bool, nilable: true},
  })

  class Profile
    json_mapping({
      first_name: {type: String, nilable: true},
      last_name: {type: String, nilable: true},
      real_name: String,
      email: String,
      skype: {type: String, nilable: true},
      phone: {type: String, nilable: true},
      image_24: {type: String, nilable: true},
      image_32: {type: String, nilable: true},
      image_48: {type: String, nilable: true},
      image_72: {type: String, nilable: true},
      image_192: {type: String, nilable: true},
    })
  end
end
