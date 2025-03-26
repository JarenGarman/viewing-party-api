require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to have_secure_password }
    it { is_expected.to have_secure_token(:api_key) }
  end

  describe "relationships" do
    it { is_expected.to have_many :viewing_party_users }
    it { is_expected.to have_many(:viewing_parties).through :viewing_party_users }
  end
end
