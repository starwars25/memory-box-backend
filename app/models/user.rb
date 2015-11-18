class User < ActiveRecord::Base
  attr_accessor :auth_token

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :box_relations, foreign_key: :user_id
  has_many :boxes, through: :box_relations, source: :box
  has_many :arguments, through: :boxes, source: :arguments

  def generate_password(password)
    if password.length < 8
      raise 'Password too short'
    end
    self.password_digest = BCrypt::Password.create(password)
  end

  def generate_auth_digest
    self.auth_token = SecureRandom.uuid
    update_attribute(:authentication_digest, BCrypt::Password.create(self.auth_token))
  end
end
