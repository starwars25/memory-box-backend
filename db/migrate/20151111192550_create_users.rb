class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :last_name
      t.string :email
      t.string :date_of_birth_string
      t.string :password_digest
      t.string :authentication_digest

      t.timestamps null: false
    end
  end
end
