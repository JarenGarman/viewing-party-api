class Movie
  attr_reader :id,
    :title,
    :release_date,
    :vote_average,
    :runtime,
    :genres,
    :summary,
    :cast,
    :total_reviews,
    :reviews

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @release_date = data[:release_date]
    @vote_average = data[:vote_average]
    @runtime = data[:runtime]
    @genres = data[:genres]
    @summary = data[:overview]
  end

  def add_reviews(data)
    @reviews = data[:results].first(5)
    @total_reviews = data[:total_results]
  end

  def add_cast(data)
    @cast = data[:cast].first(10)
  end
end
