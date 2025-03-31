class UserSerializer
  include JSONAPI::Serializer
  attributes :name,
    :username,
    :api_key,
    :viewing_parties_invited,
    :viewing_parties_hosted
end
