class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: {require: true}
  has_secure_password
  has_secure_token :api_key
  has_many :viewing_party_users
  has_many :viewing_parties, through: :viewing_party_users

  def viewing_parties_hosted
    ViewingParty.where(user_id: id).map do |party|
      {
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

  def viewing_parties_invited
    viewing_parties.map do |party|
      {
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
