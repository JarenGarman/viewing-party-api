require "rails_helper"

RSpec.describe MovieGateway do
  describe "class methods" do
    it ".get_movie", :vcr do
      movie = described_class.get_movie(278)

      expect(movie).to be_a Movie
      expect(movie.cast).to be_nil
      expect(movie.total_reviews).to be_nil
      expect(movie.reviews).to be_nil
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

    it ".movie_details", :vcr do
      movie = described_class.movie_details(278)

      expect(movie).to be_a Movie
      expect(movie.cast).not_to be_nil
      expect(movie.total_reviews).not_to be_nil
      expect(movie.reviews).not_to be_nil
    end
  end
end
