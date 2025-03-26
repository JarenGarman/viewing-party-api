require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:movie_id) }
    it { is_expected.to validate_presence_of(:movie_title) }
    it { is_expected.to validate_comparison_of(:end_time).is_greater_than(:start_time) }
  end

  describe "relationships" do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :viewing_party_users }
    it { is_expected.to have_many(:users).through :viewing_party_users }
  end
end
