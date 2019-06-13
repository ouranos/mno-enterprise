require 'rails_helper'

RSpec.describe Devise::Models::SessionLimitable, type: :request do
  include DeviseRequestSpecHelper

  # Initialize this way so the class reload is taken into account (the factory doesnt reload the User class)
  let(:user) do
    MnoEnterprise::User
      .new(attributes_for(:user, email: 'test@maestrano.com', password: 'password'))
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
    Settings.merge!(authentication: {session_limitable: {enabled: true}})
    reload_user
  end

  after do
    Settings.reload!
    reload_user
  end

  before do
    stub_audit_events

    allow(Devise).to receive(:friendly_token).and_return('session-id')

    stub_api_v2(:get, "/users", [user], [], { filter: { email: user.email }, 'page[number]': 1, 'page[size]': 1 })
    stub_api_v2(:patch, "/users/#{user.id}", user)

    login_as(user, scope: warden_scope(:user))
  end

  let!(:update_stub) do
    stub_api_v2(:post, "/users", user)
      .with(body: { data: { id: user.id, type: 'users', attributes: { unique_session_id: 'session-id' } } }.to_json)
  end

  describe 'change unique_session_id when user logs in again' do
    subject { get '/mnoe/jpi/v1/current_user.json' } # TODOs

    it 'does something' do
      subject
      expect(update_stub).to have_been_requested
    end
  end
end
