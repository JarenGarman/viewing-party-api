class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title
  has_many :users

  def self.hosted(parties)
    parties.each_with_object([]) do |party, parties|
      parties << {
        id: party.id,
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host_id: party.user_id
      }
    end
  end

  def self.invited(parties)
    parties.each_with_object([]) do |party, parties|
      parties << {
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host_id: party.user_id
      }
    end
  end
end
