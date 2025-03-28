require "rails_helper"

RSpec.describe MovieGateway do
  describe "class methods" do
    it ".get_movie", :vcr do
      expect(described_class.get_movie(278)).to be_a Movie
    end

    it ".top_rated_movies", :vcr do
      movies = described_class.top_rated_movies

      expect(movies.all?(Movie)).to be true
      expect(movies.count).to eq(20)
    end

    it ".search_movies", :vcr do
      movies = described_class.search_movies("Lord of the Rings")

      expect(movies.all?(Movie)).to be true
      expect(movies.count).to be <= 20
    end
  end
end
