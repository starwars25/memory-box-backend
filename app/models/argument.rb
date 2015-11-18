class Argument < ActiveRecord::Base
  before_create :generate_established

  validates :title, presence: true
  validates :description, presence: true
  validates :expires, presence: true
  validates :box_id, presence: true
  validates :established, presence: true

  belongs_to :box, foreign_key: :box_id
  has_many :users, through: :box, source: :users

  private
  def generate_established
    self.established = Time.now
  end
end
