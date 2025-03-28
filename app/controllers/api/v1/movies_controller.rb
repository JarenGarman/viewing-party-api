class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.request :authorization, "Bearer", Rails.application.credentials.tmdb[:token]
    end

    response = if params[:search]
      conn.get("/3/search/movie") do |req|
        req.params[:query] = params[:search].downcase
      end
    else
      conn.get("/3/movie/top_rated")
    end

    json = JSON.parse(response.body, symbolize_names: true)

    render json: MovieSerializer.new(json[:results].first(20))
  end
end
