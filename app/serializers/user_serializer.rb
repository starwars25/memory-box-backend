class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :date_of_birth
  has_many :boxes


end
