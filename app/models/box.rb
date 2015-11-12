class Box < ActiveRecord::Base
  validates :name, presence: true, length: {minimum: 4}
  has_many :box_relations, foreign_key: :box_id
  has_many :users, through: :box_relations, source: :user

  def add_users(users)
    users.each do |user_id|
      user = User.find_by(id: user_id)
      next unless user
      BoxRelation.create(user_id: user_id, box_id: self.id)
    end
  end

  def remove_user(user_id)
    relation = BoxRelation.where("user_id = #{user_id} AND box_id = #{self.id}")
    relation.each do |r|
      r.destroy
    end

  end
end
