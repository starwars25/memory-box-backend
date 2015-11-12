class CreateBoxRelations < ActiveRecord::Migration
  def change
    create_table :box_relations do |t|
      t.integer :user_id
      t.integer :box_id

      t.timestamps null: false
    end
  end
end
