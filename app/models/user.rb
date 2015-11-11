class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :last_name, presence: true
  validates :password_digest, presence: true

  def generate_password(password)
    if password.length < 8
      raise 'Password too short'
    end
    self.password_digest = BCrypt::Password.create(password)
  end
end
