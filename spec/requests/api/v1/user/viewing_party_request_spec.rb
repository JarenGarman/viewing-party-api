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
      it "returns 201 Created and provides expected fields", :vcr do
        post api_v1_user_viewing_parties_path(user3.id), params: party_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:id]).to eq(ViewingParty.last.id.to_s)
        expect(json[:data][:attributes]).to include(
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01T10:00:00.000Z",
          end_time: "2025-02-01T14:30:00.000Z",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        )
        expect(json[:data][:relationships][:users][:data].count).to eq(3)
        json[:data][:relationships][:users][:data].each do |user|
          expect(user[:id]).to eq(user1.id.to_s).or eq(user2.id.to_s).or eq(user4.id.to_s)
          expect(user[:type]).to eq("user")
        end
      end

      it "returns 201 Created and provides expected fields with nonexistent invitee", :vcr do
        party_params[:invitees] << 1000000

        post api_v1_user_viewing_parties_path(user3.id), params: party_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:id]).to eq(ViewingParty.last.id.to_s)
        expect(json[:data][:attributes]).to include(
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01T10:00:00.000Z",
          end_time: "2025-02-01T14:30:00.000Z",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        )
        expect(json[:data][:relationships][:users][:data].count).to eq(3)
        json[:data][:relationships][:users][:data].each do |user|
          expect(user[:id]).to eq(user1.id.to_s).or eq(user2.id.to_s).or eq(user4.id.to_s)
          expect(user[:type]).to eq("user")
        end
      end
    end

    context "with invalid request" do
      it "returns an error for missing field", :vcr do
        party_params[:name] = ""

        post api_v1_user_viewing_parties_path(user3.id), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Name can't be blank")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for time too short", :vcr do
        party_params[:end_time] = "2025-02-01 10:00:01"

        post api_v1_user_viewing_parties_path(user3.id), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Party must last long enough for the entire movie")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for end time before start time", :vcr do
        party_params[:end_time] = "2025-02-01 09:00:00"

        post api_v1_user_viewing_parties_path(user3.id), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Party must last long enough for the entire movie")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for nonexistent host", :vcr do
        post api_v1_user_viewing_parties_path(100000), params: party_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:not_found)
        expect(json[:message]).to eq("Host user does not exist")
        expect(json[:status]).to eq(404)
      end
    end
  end

  describe "Invite Additional User Endpoint" do
    let(:user5) { User.create!(name: "Borax", username: "brown_space", password: "flurble") }
    let(:party) {
      ViewingParty.create!(
        user: user3,
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption"
      )
    }

    before do
      party.users << user1
      party.users << user2
      party.users << user4
    end

    context "with valid request" do
      it "adds user and returns viewing party" do
        patch "/api/v1/users/#{user3.id}/viewing_parties/#{party.id}", params: {invitees_user_id: user5.id}, as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:id]).to eq(ViewingParty.last.id.to_s)
        expect(json[:data][:attributes]).to include(
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01T10:00:00.000Z",
          end_time: "2025-02-01T14:30:00.000Z",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        )
        expect(json[:data][:relationships][:users][:data].count).to eq(4)
        json[:data][:relationships][:users][:data].each do |user|
          expect(user[:id]).to eq(user1.id.to_s).or eq(user2.id.to_s).or eq(user4.id.to_s).or eq(user5.id.to_s)
          expect(user[:type]).to eq("user")
        end
      end
    end

    context "with invalid request" do
      it "returns an error for invalid host id" do
        patch "/api/v1/users/100000/viewing_parties/#{party.id}", params: {invitees_user_id: user5.id}, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:message]).to eq("Host user does not exist")
        expect(json[:status]).to eq(404)
      end

      it "returns an error for invalid party id" do
        patch "/api/v1/users/#{user3.id}/viewing_parties/100000", params: {invitees_user_id: user5.id}, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:message]).to eq("Viewing party does not exist")
        expect(json[:status]).to eq(404)
      end

      it "returns an error for invalid user id" do
        patch "/api/v1/users/#{user3.id}/viewing_parties/#{party.id}", params: {invitees_user_id: 100000}, as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:message]).to eq("Invitee does not exist")
        expect(json[:status]).to eq(404)
      end
    end
  end
end
