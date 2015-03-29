# == Schema Information
#
# Endpoint: 
#  - /v1/app_instances
#  - /v1/organizations/:organization_id/app_instances
#
#  id                   :integer         not null, primary key
#  uid                  :string(255)
#  name                 :string(255)
#  status               :string(255)
#  app_id               :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  started_at           :datetime
#  stack                :string(255)
#  owner_id             :integer
#  owner_type           :string(255)
#  terminated_at        :datetime
#  stopped_at           :datetime
#  billing_type         :string(255)
#  autostop_at          :datetime
#  autostop_interval    :integer
#  next_status          :string(255)
#  soa_enabled          :boolean         default(FALSE)
#
# ===> to be confirmed
#  http_url
#  durations                :text
#  microsoft_licence_id :integer
#

module MnoEnterprise
  class AppInstance < BaseResource
    
    attributes :id, :uid, :name, :status, :app_id, :created_at, :updated_at, :started_at, :stack, :owner_id,
    :owner_type, :terminated_at, :stopped_at, :billing_type, :autostop_at, :autostop_interval,
    :next_status, :soa_enabled
    
    #==============================================================
    # Constants
    #==============================================================
    ACTIVE_STATUSES = [:running,:stopped,:staged,:provisioning,:starting,:stopping]
    TERMINATION_STATUSES = [:terminating,:terminated]
    
    #==============================================================
    # Associations
    #==============================================================
    belongs_to :owner, class_name: 'MnoEnterprise::Organization'
    belongs_to :app, class_name: 'MnoEnterprise::App'
    
    # Return true if the instance can be considered active
    def active?
      ACTIVE_STATUSES.include?(self.status.to_sym) ||
      (TERMINATION_STATUSES.include?(self.status.to_sym) && self.terminated_at > 3.minutes.ago)
    end
  end
end