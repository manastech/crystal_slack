module Slack::SerializableEvent
  macro use_optional_discriminator(field, mapping)
    {% unless mapping.is_a?(HashLiteral) || mapping.is_a?(NamedTupleLiteral) %}
      {% mapping.raise "mapping argument must be a HashLiteral or a NamedTupleLiteral, not #{mapping.class_name.id}" %}
    {% end %}

    def self.new(pull : ::JSON::PullParser)
      location = pull.location

      discriminator_value = nil

      json = String.build do |io|
        JSON.build(io) do |builder|
          builder.start_object
          pull.read_object do |key|
            if key == {{field.id.stringify}}
              value_kind = pull.kind
              case value_kind
              when .string?
                discriminator_value = pull.string_value
              when .int?
                discriminator_value = pull.int_value
              when .bool?
                discriminator_value = pull.bool_value
              else
                raise ::JSON::SerializableError.new("JSON discriminator field '{{field.id}}' has an invalid value type of #{value_kind.to_s}", to_s, nil, *location, nil)
              end
              builder.field(key, discriminator_value)
              pull.read_next
            else
              builder.field(key) { pull.read_raw(builder) }
            end
          end
          builder.end_object
        end
      end

      unless discriminator_value
        return self.new_from_json_pull_parser JSON::PullParser.new json
      end

      case discriminator_value
      {% for key, value in mapping %}
        {% if mapping.is_a?(NamedTupleLiteral) %}
          when {{key.id.stringify}}
        {% else %}
          {% if key.is_a?(StringLiteral) %}
            when {{key}}
          {% elsif key.is_a?(NumberLiteral) || key.is_a?(BoolLiteral) %}
            when {{key.id}}
          {% elsif key.is_a?(Path) %}
            when {{key.resolve}}
          {% else %}
            {% key.raise "mapping keys must be one of StringLiteral, NumberLiteral, BoolLiteral, or Path, not #{key.class_name.id}" %}
          {% end %}
        {% end %}
        {{value.id}}.from_json(json)
      {% end %}
      else
        raise ::JSON::SerializableError.new("Unknown '{{field.id}}' discriminator value: #{discriminator_value.inspect}", to_s, nil, *location, nil)
      end
    end
  end
end
