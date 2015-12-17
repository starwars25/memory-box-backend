class AddActivatedToArguments < ActiveRecord::Migration
  def change
    add_column :arguments, :activated, :boolean, default: false
  end
end
