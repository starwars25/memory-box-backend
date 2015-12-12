class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  attr_accessor :auth_token

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :avatar, presence: true

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

  def token_valid?(token)
    BCrypt::Password.new(self.authentication_digest) == token
  end

  def changes_after?(date)
    return true if self.updated_at > date
    self.boxes.each do |box|
      return true if box.updated_at > date
      box.arguments.each do |argument|
        return true if argument.updated_at > date
      end
    end
    false
  end
end
