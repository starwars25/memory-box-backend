class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar
  has_many :boxes


end
