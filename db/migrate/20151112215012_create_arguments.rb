class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.string :title
      t.string :description
      t.date :expires
      t.integer :box_id

      t.timestamps null: false
    end
  end
end
