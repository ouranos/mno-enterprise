module MnoEnterprise
  class Tenant < BaseResource
    attributes :frontend_config

    def self.show
      self.get('tenant').tap {|t| t.clear_attribute_changes!}
    end
  end
end
