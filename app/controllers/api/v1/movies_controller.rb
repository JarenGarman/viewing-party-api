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

    formatted_json = json[:results].each_with_object([]) do |movie, formatted_movies|
      break if formatted_movies.length == 20

      formatted_movies << {
        id: movie[:id],
        type: "movie",
        attributes: {
          title: movie[:title],
          vote_average: movie[:vote_average]
        }
      }
    end

    render json: {data: formatted_json}
  end
end
