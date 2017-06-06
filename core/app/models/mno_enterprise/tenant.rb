module MnoEnterprise
  class Tenant < BaseResource
    attributes :frontend_config

    validate :must_match_json_schema

    CONFIG_JSON_SCHEMA = {
      '$schema': "http://json-schema.org/draft-04/schema#",
      type: "object",
      title: "Settings",
      properties: {
        audit_log: {
          type: "object",
          properties: {
            enabled: {
              type: "boolean",
              description: "Display Audit Log in Organization Panel",
              default: false
            }
          }
        },
        marketplace: {
          type: "object",
          properties: {
            enabled: {
              type: "boolean",
              default: true
            },
            comparison: {
              type: "object",
              properties: {
                enabled: {
                  type: "boolean",
                  default: false
                }
              }
            }
          }
        },
        pricing: {
          type: "object",
          properties: {
            enabled: {
              type: "boolean",
              description: "Display App Pricing on Marketplace",
              default: true
            }
          }
        },
        dock: {
          type: "object",
          properties: {
            enabled: {
              type: "boolean",
              description: "Enable the App Dock",
              default: true
            }
          }
        },
        developer: {
          type: "object",
          properties: {
            enabled: {
              type: "boolean",
              description: "Display the Developer section on \"My Account\"",
              default: false
            }
          }
        },
        admin_panel: {
          description: "Admin Panel Settings",
          type: "object",
          properties: {
            apps_management: {
              type: "object",
              properties: {
                enabled: {
                  type: "boolean"
                }
              }
            },
            audit_log: {
              type: "object",
              properties: {
                enabled: {
                  type: "boolean",
                  description: "disable the audit log"
                }
              }
            },
            customer_management: {
              type: "object",
              properties: {
                organization: {
                  type: "object",
                  properties: {
                    enabled: {
                      type: "boolean"
                    }
                  }
                },
                user: {
                  type: "object",
                  properties: {
                    enabled: {
                      type: "boolean"
                    }
                  }
                }
              }
            },
            finance: {
              type: "object",
              properties: {
                enabled: {
                  type: "boolean",
                  description: "disable the finance page, the financial kpis and the invoices in the admin panel"
                }
              }
            },
            impersonation: {
              type: "object",
              properties: {
                disabled: {
                  type: "boolean"
                }
              }
            },
            staff: {
              type: "object",
              properties: {
                enabled: {
                  type: "boolean"
                }
              }
            }
          }
        }
      }
    }.freeze

    def self.show
      self.get('tenant').tap {|t| t.clear_attribute_changes!}
    end

    private

    # Validates frontend_config against the JSON Schema
    def must_match_json_schema
      json_errors = JSON::Validator.fully_validate(CONFIG_JSON_SCHEMA, frontend_config)
      json_errors.each do |error|
        errors.add(:frontend_config, error)
      end
    end
  end
end
