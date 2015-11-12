class Argument < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :expires, presence: true
  validates :box_id, presence: true

  belongs_to :box, foreign_key: :box_id
  has_many :users, through: :box, source: :users
end
