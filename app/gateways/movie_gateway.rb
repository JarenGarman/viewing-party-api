class MovieGateway
  def self.get_movie(id)
    response = connection.get("/3/movie/#{id}")

    json = JSON.parse(response.body, symbolize_names: true)
    Movie.new(json)
  end

  private_class_method

  def self.connection
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.request :authorization, "Bearer", Rails.application.credentials.tmdb[:token]
    end
  end
end
