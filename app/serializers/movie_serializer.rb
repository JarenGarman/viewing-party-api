class MovieSerializer
  include JSONAPI::Serializer
  attributes :title,
    :vote_average,
    :summary,
    :total_reviews

  attribute :release_year do |movie|
    movie.release_date.first(4).to_i
  end

  attribute :runtime do |movie|
    h, m = movie.runtime.divmod(60)
    "#{h} hours, #{m} minutes"
  end

  attribute :genres do |movie|
    movie.genres.pluck(:name)
  end

  attribute :cast do |movie|
    movie.cast.map do |cast_member|
      {
        character: cast_member[:character],
        actor: cast_member[:name]
      }
    end
  end

  attribute :reviews do |movie|
    movie.reviews.map do |review|
      {
        author: review[:author],
        review: review[:content]
      }
    end
  end
end
