# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_user
  @user = User.create(email: Faker::Internet.email, password_digest: @password, date_of_birth: 30.years.ago, name: Faker::Internet.user_name, avatar: @file)
end

def create_boxes
  @box = Box.create(title: Faker::Lorem.words(3), date_of_establishment: Time.now)
end

def create_box_relationships
  box = @boxes.sample
  user = @users.sample
  while box.contains_user? user
    user = @users.sample
  end
  BoxRelation.create(box_id: box.id, user_id: user.id)

end

def create_arguments
  @argument = Argument.create!(title: Faker::Lorem.sentence,
                               description: Faker::Lorem.paragraph,
                               expires: Faker::Date.between(14.days.from_now, 30.years.from_now),
                               established: Time.now,
                               box_id: @boxes.sample.id,
                               video: @video)
end

start = Time.now

path = File.dirname(__FILE__)
path = File.expand_path('..', path)
path = File.join(path, '/public/chevrolet.jpg')
@file = nil
File.open(path, 'r') do |f|
  @file = f
  @password = BCrypt::Password.create('nice_password')
  100.times do
    create_user
  end

end


50.times do
  create_boxes
end

@users = User.all
@boxes = Box.all

100.times do
  create_box_relationships
end


path = File.dirname(__FILE__)
path = File.expand_path('..', path)
path = File.join(path, '/public/Video.mov')
@video = nil
File.open(path, 'r') do |f|
  @video = f
  50.times do
    create_arguments
  end
end

puts "Finished in #{Time.now - start} seconds"
