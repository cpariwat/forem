require "rails_helper"

RSpec.describe TagModerators::AddTrustedRole, type: :service do
  it "adds the trusted role to a user" do
    user = create(:user)
    expect { described_class.call(user) }.to change { user.reload.roles }.by(1)
  end

  it "does not add the fole for banned users" do
    user = create(:user, :banned)
    expect { described_class.call(user) }.not_to change { user.reload.roles }
  end
end
