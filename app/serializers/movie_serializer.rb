class MovieSerializer
  include JSONAPI::Serializer

  set_type :movie
  set_id do |movie|
    movie[:id]
  end

  attribute :title do |movie|
    movie[:title]
  end

  attribute :vote_average do |movie|
    movie[:vote_average]
  end
end
