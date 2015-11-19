module TestHelper
  def create_users
    @first = User.new(name: 'Sanya Bogomolov', email: 'a.starwars.d@gmail.com')
    @first.generate_password 'nice_password'
    @first.save

    @second = User.new(name: 'Fedor Tsarenko', email: 'pidor@gmail.com')
    @second.generate_password 'nice_password'
    @second.save


    @third = User.new(name: 'Den Yarinskih', email: 'den@gmail.com')
    @third.generate_password 'nice_password'
    @third.save
  end

  def create_boxes
    @first_box = Box.create(title: 'FirstBox')
    @first_box.add_users([@first.id, @second.id, @third.id])

    @second_box = Box.create(title: 'SecondBox')
    @second_box.add_users([@second.id, @third.id])
  end

  def clean
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

  end

  def log_in(user)
    user.generate_auth_digest
    user.auth_token
  end
end