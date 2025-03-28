class Api::V1::MoviesController < ApplicationController
  def index
    response = if params[:search]
      MovieGateway.search_movies(params[:search])
    else
      MovieGateway.top_rated_movies
    end

    render json: MovieSerializer.new(response)
  end
end
