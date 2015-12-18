class Argument < ActiveRecord::Base
  before_create :generate_established

  mount_uploader :video, VideoUploader

  validates :title, presence: true
  validates :description, presence: true
  validates :expires, presence: true
  validates :box_id, presence: true
  belongs_to :box, foreign_key: :box_id
  has_many :users, through: :box, source: :users

  def has_user?(user_id)

    user_ids = []
    self.users.each {|u| user_ids << u.id}
    user_ids.include? user_id
  end

  private
  def generate_established
    self.established = Time.now
  end
end
