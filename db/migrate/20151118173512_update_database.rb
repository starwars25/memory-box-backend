class UpdateDatabase < ActiveRecord::Migration
  def change

    # Box

    remove_column :boxes, :name
    add_column :boxes, :title, :string
    add_column :boxes, :date_of_establishment, :date

    # User

    remove_column :users, :date_of_birth_string
    remove_column :users, :name
    remove_column :users, :last_name
    add_column :users, :date_of_birth, :date
    add_column :users, :name, :string

    # Argument

    add_column :arguments, :established, :date

  end
end
