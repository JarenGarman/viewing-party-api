require "rails_helper"

RSpec.describe "Movies Endpoint" do
  describe "happy path" do
    it "can retrieve top rated movies", :vcr do
      get "/api/v1/movies"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(20)
      json[:data].each do |movie|
        expect(movie[:id]).to be_an(Integer)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes][:title]).to be_a(String)
        expect(movie[:attributes][:vote_average]).to be_a(Float)
      end
    end

    it "can search movie titles", :vcr do
      get "/api/v1/movies?search=Shrek"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(20)
      json[:data].each do |movie|
        expect(movie[:id]).to be_an(Integer)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes][:title]).to be_a(String)
        expect(movie[:attributes][:title].downcase).to include("shrek")
        expect(movie[:attributes][:vote_average]).to be_a(Float)
      end
    end
  end
end
