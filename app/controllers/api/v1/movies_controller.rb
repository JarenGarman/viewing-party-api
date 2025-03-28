class Api::V1::MoviesController < ApplicationController
  def index
    movies = if params[:search]
      MovieGateway.search_movies(params[:search])
    else
      MovieGateway.top_rated_movies
    end

    render json: MovieSerializer.new(movies)
  end
end
