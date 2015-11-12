class BoxRelation < ActiveRecord::Base
  validates :box_id, presence: true
  validates :user_id, presence: true

  belongs_to :box, foreign_key: :box_id
  belongs_to :user, foreign_key: :user_id
end
