class AddFinishedToArgument < ActiveRecord::Migration
  def change
    add_column :arguments, :finished, :boolean, default: false
  end
end
