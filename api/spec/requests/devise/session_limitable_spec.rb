require 'rails_helper'

RSpec.describe Devise::Models::SessionLimitable, type: :request do
  include DeviseRequestSpecHelper

  # Initialize this way so the class reload is taken into account (the factory doesnt reload the User class)
  let(:user) do
    MnoEnterprise::User
      .new(attributes_for(:user, email: 'test@maestrano.com', password: 'password', sso_session: 'session-id'))
      .tap { |e| e.clear_changes_information } # Make sure the object is not dirty
  end

  # Reload User class to load proper configuration according to Settings
  def reload_user
    # Removes MnoEnterprise::User from object-space:
    MnoEnterprise.send(:remove_const, :User)
    # Reloads the module (require might also work):
    load '../core/app/models/mno_enterprise/user.rb'
  end

  before do
    Settings.merge!(authentication: { session_limitable: { enabled: true } })
    reload_user

    stub_audit_events
    stub_api_v2(:post, "/users", user)
    login_as(user, scope: warden_scope(:user))
  end

  after do
    Settings.reload!
    reload_user
  end

  describe 'fetch' do
    subject { get '/mnoe/jpi/v1/current_user.json' }
    
    it 'fetches the user' do
      subject
      expect(response).to have_http_status(:success)
    end

    context 'when another session got created in the meantime' do
      before do
        Warden.on_next_request do |proxy|
          proxy.session(warden_scope(:user))['sso_session'] = 'another-session-id'
        end
      end

      # TODO: spec doesn't pass / Warden::Manager.after_set_user only: :fetch is never called
      # it 'logs the user out and return 401' do
      #   subject
      #   expect(response).to have_http_status(:unauthorized)
      # end
    end
  end
end