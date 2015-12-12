class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :date_of_birth, :updated_at
  has_many :boxes


end
