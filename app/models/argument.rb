class Argument < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :expires, presence: true
  validates :box_id, presence: true
end
