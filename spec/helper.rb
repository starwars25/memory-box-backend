module TestHelper
  def create_users
    first = User.new(name: 'Sanya', last_name: 'Bogomolov', email: 'a.starwars.d@gmail.com')
    first.generate_password 'nice_password'
    first.save

    second = User.new(name: 'Fedor', last_name: 'Tsarenki', email: 'pidor@gmail.com')
    second.generate_password 'nice_password'
    second.save
  end
end