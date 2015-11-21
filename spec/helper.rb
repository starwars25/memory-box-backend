module TestHelper
  def create_users
    @first = User.new(name: 'Sanya Bogomolov', email: 'a.starwars.d@gmail.com')
    @first.generate_password 'nice_password'
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/chevrolet.jpg") do |f|
      @first.avatar = f
    end
    @first.save

    @second = User.new(name: 'Fedor Tsarenko', email: 'pidor@gmail.com')
    @second.generate_password 'nice_password'
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/chevrolet.jpg") do |f|
      @second.avatar = f
    end
    @second.save


    @third = User.new(name: 'Den Yarinskih', email: 'den@gmail.com')
    @third.generate_password 'nice_password'
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/chevrolet.jpg") do |f|
      @third.avatar = f
    end
    @third.save
  end

  def create_boxes
    @first_box = Box.create(title: 'FirstBox')
    @first_box.add_users([@first.id, @second.id])

    @second_box = Box.create(title: 'SecondBox')
    @second_box.add_users([@second.id, @third.id])
  end

  def create_arguments
    @first_argument = Argument.new(title: 'TestArgument', description: 'Description', box_id: @first_box.id, expires: 1.year.from_now)
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/Video.mov") do |f|
      @first_argument.video = f
    end
    @first_argument.save
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