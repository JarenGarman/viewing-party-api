require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "with valid request" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).not_to have_key(:password)
        expect(json[:data][:attributes]).not_to have_key(:password_confirmation)
      end
    end

    context "with invalid request" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "myspace_creator", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).not_to have_key(:password)
      expect(json[:data][0][:attributes]).not_to have_key(:password_digest)
      expect(json[:data][0][:attributes]).not_to have_key(:api_key)
    end
  end

  describe "Get User Endpoint" do
    context "with valid request" do
      it "retrieves a single user along with their viewing parties" do
        user1 = User.create!(name: "Tom", username: "myspace_creator", password: "test123")
        user2 = User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
        user3 = User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")
        party1 = ViewingParty.create!(
          user: user1,
          name: "Titanic Watch Party",
          start_time: "2025-05-01 10:00:00",
          end_time: "2025-05-01 14:30:00",
          movie_id: 597,
          movie_title: "Titanic"
        )
        party1.users << user2
        party1.users << user3
        party2 = ViewingParty.create!(
          user: user2,
          name: "LOTR Viewing Party",
          start_time: "2025-03-11 10:00:00",
          end_time: "2025-03-11 15:30:00",
          movie_id: 120,
          movie_title: "The Lord of the Rings: The Fellowship of the Ring"
        )
        party2.users << user1
        party2.users << user3
        party3 = ViewingParty.create!(
          user: user3,
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01 10:00:00",
          end_time: "2025-02-01 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        )
        party3.users << user1
        party3.users << user2
        party4 = ViewingParty.create!(
          user: user3,
          name: "Let's watch clueless together!",
          start_time: "2025-01-15 10:00:00",
          end_time: "2025-01-15 14:30:00",
          movie_id: 9603,
          movie_title: "Clueless"
        )
        party4.users << user1
        party4.users << user2

        get api_v1_user_path(user1.id)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(user1.id.to_s)
        expect(json[:data][:attributes][:name]).to eq("Tom")
        expect(json[:data][:attributes][:username]).to eq("myspace_creator")
        expect(json[:data][:attributes]).not_to have_key(:api_key)
        expect(json[:data][:attributes]).not_to have_key(:password)
        expect(json[:data][:attributes]).not_to have_key(:password_confirmation)

        json[:data][:attributes][:viewing_parties_hosted].each do |party|
          expect(party[:id]).to be_an Integer
          expect(party[:name]).to be_a String
          expect(party[:start_time]).to be_a String
          expect(party[:end_time]).to be_a String
          expect(party[:movie_id]).to be_an Integer
          expect(party[:movie_title]).to be_a String
          expect(party[:host_id]).to eq(user1.id)
        end

        json[:data][:attributes][:viewing_parties_invited].each do |party|
          expect(party).not_to have_key(:id)
          expect(party[:name]).to be_a String
          expect(party[:start_time]).to be_a String
          expect(party[:end_time]).to be_a String
          expect(party[:movie_id]).to be_an Integer
          expect(party[:movie_title]).to be_a String
          expect(party[:host_id]).not_to eq(user1.id)
        end
      end
    end

    context "with invalid request" do
      it "returns error for nonexistent user" do
        get api_v1_user_path(100000)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:not_found)
        expect(json[:message]).to eq("Invalid User ID")
        expect(json[:status]).to eq(404)
      end
    end
  end
end
