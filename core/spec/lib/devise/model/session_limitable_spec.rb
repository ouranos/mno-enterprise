require 'rails_helper'

RSpec.describe Devise::Models::SessionLimitable, type: :model do
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
    load 'app/models/mno_enterprise/user.rb'
  end

  before do
    Settings.merge!(authentication: {session_limitable: {enabled: true}})
    reload_user
  end

  after do
    Settings.reload!
    reload_user
  end

  describe '#update_unique_session_id!' do
    subject { user.update_unique_session_id!('session-id') }

    before do
      stub_api_v2(:get, '/users', [user], [], {filter: {email: 'test@maestrano.com'}, page: {number: 1, size: 1}})
    end

    let!(:update_stub) do
      stub_api_v2(:post, "/users", user)
        .with(body: { data: { id: user.id, type: 'users', attributes: { unique_session_id: 'session-id' } } }.to_json)
    end

    it { expect(user).to respond_to(:update_unique_session_id!) }

    it 'updates the session id' do
      subject
      expect(update_stub).to have_been_requested
    end
  end
end
