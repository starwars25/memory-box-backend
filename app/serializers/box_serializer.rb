class BoxSerializer < ActiveModel::Serializer
  attributes :id, :title, :date_of_establishment
  has_many :arguments

  ActiveSupport.on_load(:active_model_serializers) do
    # Disable for all serializers (except ArraySerializer)
    ActiveModel::Serializer.root = false

    # Disable for ArraySerializer
    ActiveModel::ArraySerializer.root = false
  end
end
