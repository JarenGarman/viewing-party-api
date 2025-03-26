require "rails_helper"

RSpec.describe "Viewing Party API", type: :request do
  let(:user1) { User.create!(name: "Tom", username: "myspace_creator", password: "test123") }
  let(:user2) { User.create!(name: "Oprah", username: "oprah", password: "abcqwerty") }
  let(:user3) { User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy") }
  let(:user4) { User.create!(name: "Lorax", username: "green_space", password: "blurble") }
  let(:party_params) {
    {
      name: "Juliet's Bday Movie Bash!",
      start_time: "2025-02-01 10:00:00",
      end_time: "2025-02-01 14:30:00",
      movie_id: 278,
      movie_title: "The Shawshank Redemption",
      invitees: [user1.id, user2.id, user4.id]
    }
  }

  describe "Create Viewing Party Endpoint" do
    context "with valid request" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_user_viewing_party_path(user3.id), params: party_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:id]).to eq(ViewingParty.last.id.to_s)
        expect(json[:data][:attributes]).to include(
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01 10:00:00",
          end_time: "2025-02-01 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        )
        expect(json[:relationships][:users][:data].count).to eq(3)
        json[:relationships][:users][:data].each do |user|
          expect(user[:id]).to eq(user1.id.to_s).or eq(user2.id.to_s).or eq(user4.id.to_s)
          expect(user[:type]).to eq("user")
        end
      end

      it "returns 201 Created and provides expected fields with nonexistent invitee" do
        party_params[:invitees] << 1000000

        post api_v1_user_viewing_party_path(user3.id), params: party_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:id]).to eq(ViewingParty.last.id.to_s)
        expect(json[:data][:attributes]).to include(
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01 10:00:00",
          end_time: "2025-02-01 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        )
        expect(json[:relationships][:users][:data].count).to eq(3)
        json[:relationships][:users][:data].each do |user|
          expect(user[:id]).to eq(user1.id.to_s).or eq(user2.id.to_s).or eq(user4.id.to_s)
          expect(user[:type]).to eq("user")
        end
      end
    end

    context "with invalid request" do
      it "returns an error for missing field" do
        party_params[:name] = ""

        post api_v1_user_viewing_party_path(user3.id), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Name can't be blank")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for time too short" do
        party_params[:end_time] = "2025-02-01 10:00:01"

        post api_v1_user_viewing_party_path(user3.id), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Party duration can't be less than movie runtime")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for end time before start time" do
        party_params[:end_time] = "2025-02-01 09:00:00"

        post api_v1_user_viewing_party_path(user3.id), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Party end time can't be before start time")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for nonexistent host" do
        post api_v1_user_viewing_party_path(100000), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:not_found)
        expect(json[:message]).to eq("Host user does not exist")
        expect(json[:status]).to eq(404)
      end
    end
  end
end
