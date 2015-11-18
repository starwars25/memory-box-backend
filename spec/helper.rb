module TestHelper
  def create_users
    @first = User.new(name: 'Sanya Bogomolov', email: 'a.starwars.d@gmail.com')
    @first.generate_password 'nice_password'
    @first.save

    @second = User.new(name: 'Tsarenko', email: 'pidor@gmail.com')
    @second.generate_password 'nice_password'
    @second.save
  end

  def clean
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

  end
end