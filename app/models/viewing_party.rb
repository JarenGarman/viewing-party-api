class ViewingParty < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: {greater_than: :start_time}
  validates :movie_id, presence: true
  validates :movie_title, presence: true
  belongs_to :user
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users
end
