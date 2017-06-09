module MnoEnterprise
  class Tenant < BaseResource
    attributes :frontend_config

    validate :must_match_json_schema

    def self.show
      self.get('tenant').tap {|t| t.clear_attribute_changes!}
    end

    private

    # Validates frontend_config against the JSON Schema
    def must_match_json_schema
      json_errors = JSON::Validator.fully_validate(MnoEnterprise::TenantConfig::CONFIG_JSON_SCHEMA, frontend_config)
      json_errors.each do |error|
        errors.add(:frontend_config, error)
      end
    end
  end
end
