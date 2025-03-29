class Api::V1::MoviesController < ApplicationController
  def show
    movie = MovieGateway.movie_details(params[:id])

    render json: MovieSerializer.new(movie)
  end

  def index
    movies = if params[:search]
      MovieGateway.search_movies(params[:search])
    else
      MovieGateway.top_rated_movies
    end

    render json: MovieSerializer.new(movies, {fields: {movie: [:title, :vote_average]}})
  end
end
