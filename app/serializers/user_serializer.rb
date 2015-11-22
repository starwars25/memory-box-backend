class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar
  has_many :boxes

  ActiveSupport.on_load(:active_model_serializers) do
    # Disable for all serializers (except ArraySerializer)
    ActiveModel::Serializer.root = false

    # Disable for ArraySerializer
    ActiveModel::ArraySerializer.root = false
  end
end
