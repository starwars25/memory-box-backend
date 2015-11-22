class ArgumentSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :expires, :established, :finished, :video
end
