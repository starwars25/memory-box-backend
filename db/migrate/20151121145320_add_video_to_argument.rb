class AddVideoToArgument < ActiveRecord::Migration
  def change
    add_column :arguments, :video, :string
  end
end
