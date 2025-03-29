require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "Top Rated Movies Endpoint" do
    it "can retrieve top rated movies", :vcr do
      get api_v1_movies_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(20)
      json[:data].each do |movie|
        expect(movie[:id]).to be_a(String)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes][:title]).to be_a(String)
        expect(movie[:attributes][:vote_average]).to be_a(Float)
      end
    end
  end

  describe "Search Movies Endpoint" do
    it "can search movie titles", :vcr do
      get api_v1_movies_path, params: {search: "Lord of the Rings"}

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to be <= 20
      json[:data].each do |movie|
        expect(movie[:id]).to be_a(String)
        expect(movie[:type]).to eq("movie")
        expect(movie[:attributes][:title]).to be_a(String)
        expect(movie[:attributes][:title].downcase).to include("lord of the rings").or include("hobbit").or include("return of the king")
        expect(movie[:attributes][:vote_average]).to be_a(Float)
      end
    end
  end

  describe "Show Movie Endpoint" do
    it "returns movie with expected attributes", :vcr do
      get api_v1_movie_path(278)

      expect(response).to be_successful
      movie = JSON.parse(response.body, symbolize_names: true)[:data]
      attributes = movie[:attributes]

      expect(movie[:id]).to eq("278")
      expect(movie[:type]).to eq("movie")
      expect(attributes[:title]).to be_a String
      expect(attributes[:release_year]).to be_an Integer
      expect(attributes[:vote_average]).to be_a Float
      expect(attributes[:runtime]).to be_a String
      expect(attributes[:genres].all?(String)).to be true
      expect(attributes[:summary]).to be_a String
      expect(attributes[:cast].length).to be <= 10
      expect(attributes[:total_reviews]).to be_an Integer
      expect(attributes[:reviews].length).to be <= 5

      attributes[:cast].each do |cast_member|
        expect(cast_member[:character]).to be_a String
        expect(cast_member[:actor]).to be_a String
      end

      attributes[:reviews].each do |review|
        expect(review[:author]).to be_a String
        expect(review[:review]).to be_a String
      end
    end
  end
end
