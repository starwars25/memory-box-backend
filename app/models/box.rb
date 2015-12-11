class Box < ActiveRecord::Base
  before_create :generate_date

  validates :title, presence: true, length: {minimum: 5}
  has_many :box_relations, foreign_key: :box_id
  has_many :users, through: :box_relations, source: :user
  has_many :arguments, foreign_key: :box_id


  # Deprecated
  def add_users(users)
    users.each do |user_id|
      user = User.find_by(id: user_id)
      next unless user
      # next if is_member user_id
      # byebug
      # byebug
      BoxRelation.create(user_id: user.id, box_id: self.id)
    end
  end

  def contains_user?(user)
    false
  end

  def add_user(user_id)
    user = User.find_by(id: user_id)
    BoxRelation.create(user_id: user.id, box_id: self.id) if user && !is_member(user.id)
  end

  def is_member(user_id)
    self.users_ids.include? user_id
  end


  def remove_user(user_id)
    relation = BoxRelation.where("user_id = #{user_id} AND box_id = #{self.id}")
    relation.each do |r|
      r.destroy
    end

  end

  def users_ids
    ids = []
    self.users.each do |u|
      ids << u.id
    end
    ids


  end

  def add_argument(title, content, expires, video)
    argument = Argument.new(title: title, description: content, expires: expires, box_id: self.id)
    argument.video = video
    argument.save
  end

  def remove_argument(id)
    argument = Argument.find_by(id: id)
    if argument
      argument.destroy
    end
  end

  def generate_date
    self.date_of_establishment = Time.new
  end
end
