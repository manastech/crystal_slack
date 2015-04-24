class Slack::API::Channel
  json_mapping({
    id: String,
    name: String,
    created: Int64,
    creator: String,
    is_archived: Bool,
    is_member: Bool,
    num_members: Int32,
    topic: Topic,
    purpose: Topic,
  })

  struct Topic
    json_mapping({
      value: String,
      creator: String,
      last_set: Int64,
    })
  end
end
