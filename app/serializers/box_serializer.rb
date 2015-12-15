class BoxSerializer < ActiveModel::Serializer
  attributes :id, :title, :date_of_establishment, :updated_at, :users_ids
  has_many :arguments

  ActiveSupport.on_load(:active_model_serializers) do
    # Disable for all serializers (except ArraySerializer)
    ActiveModel::Serializer.root = false

    # Disable for ArraySerializer
    ActiveModel::ArraySerializer.root = false
  end

  def users_ids
    object.user_ids
  end
end
