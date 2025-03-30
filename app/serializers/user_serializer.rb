class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  attribute :viewing_parties_hosted do |user|
    ViewingPartySerializer.hosted(ViewingParty.where(user_id: user.id))
  end

  attribute :viewing_parties_invited do |user|
    ViewingPartySerializer.invited(user.viewing_parties)
  end
end
