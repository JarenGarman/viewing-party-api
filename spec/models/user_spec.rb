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

  describe "instance methods" do
    let(:user1) { described_class.create!(name: "me", username: "its_me", password: "abc123") }
    let(:user2) { described_class.create!(name: "you", username: "its_you", password: "cba321") }

    describe "#viewing_parties_hosted" do
      subject(:hosted) { user1.viewing_parties_hosted }

      context "with no parties" do
        it { is_expected.to eq([]) }
      end

      context "with parties" do
        it "returns array of hosted parties" do
          party = ViewingParty.create!(
            user: user1,
            name: "Juliet's Bday Movie Bash!",
            start_time: "2025-02-01 10:00:00",
            end_time: "2025-02-01 14:30:00",
            movie_id: 278,
            movie_title: "The Shawshank Redemption"
          )

          expect(hosted).to eq([{
            id: party.id,
            name: party.name,
            start_time: party.start_time,
            end_time: party.end_time,
            movie_id: party.movie_id,
            movie_title: party.movie_title,
            host_id: party.user_id
          }])
        end
      end
    end

    describe "#viewing_parties_invited" do
      subject(:invited) { user1.viewing_parties_invited }

      context "with no parties" do
        it { is_expected.to eq([]) }
      end

      context "with parties" do
        it "returns array of invited parties" do
          party = ViewingParty.create!(
            user: user2,
            name: "Juliet's Bday Movie Bash!",
            start_time: "2025-02-01 10:00:00",
            end_time: "2025-02-01 14:30:00",
            movie_id: 278,
            movie_title: "The Shawshank Redemption"
          )
          party.users << user1

          expect(invited).to eq([{
            name: party.name,
            start_time: party.start_time,
            end_time: party.end_time,
            movie_id: party.movie_id,
            movie_title: party.movie_title,
            host_id: party.user_id
          }])
        end
      end
    end
  end
end
