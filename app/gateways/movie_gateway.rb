class MovieGateway
  def self.get_movie(id)
    response = connection.get("/3/movie/#{id}")

    json = JSON.parse(response.body, symbolize_names: true)
    Movie.new(json)
  end

  def self.top_rated_movies
    response = connection.get("/3/movie/top_rated")

    json = JSON.parse(response.body, symbolize_names: true)
    json[:results].first(20).map do |data|
      Movie.new(data)
    end
  end

  def self.search_movies(search)
    response = connection.get("/3/search/movie") do |req|
      req.params[:query] = search.downcase
    end

    json = JSON.parse(response.body, symbolize_names: true)
    json[:results].first(20).map do |data|
      Movie.new(data)
    end
  end

  private_class_method

  def self.connection
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.request :authorization, "Bearer", Rails.application.credentials.tmdb[:token]
    end
  end
end
