class BoxRelation < ActiveRecord::Base
  validates :box_id, presence: true
  validates :user_id, presence: true
end
