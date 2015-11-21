require 'rails_helper'

RSpec.describe User, type: :model do
  it "should validate presence of name" do
    before = User.count
    user = User.new(name: '', email: 'foobar@foo.bar')
    user.generate_password('nice_password')
    user.save
    expect(User.count).to eql(before)
  end

  it "should validate presence of email" do
    before = User.count
    user = User.new(name: 'foo', email: '')
    user.generate_password('nice_password')
    user.save
    expect(User.count).to eql(before)
  end

  it "should validate uniqueness of email" do
    before = User.count
    user = User.new(name: 'foo', email: 'foobar@bar.com')
    user.generate_password('nice_password')
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/chevrolet.jpg") do |f|
      user.avatar = f
    end

    user.save
    expect(User.count).to eql(before + 1)

    user = User.new(name: 'foo', email: 'foobar@bar.com')
    user.generate_password('nice_password')
    user.save
    expect(User.count).to eql(before + 1)

  end




  it "should validate length of password" do
    before = User.count
    user = User.new(name: 'foo', email: 'foobar@foo.bar')
    expect {user.generate_password('foo')}.to raise_error 'Password too short'
    user.save
    expect(User.count).to eql(before)
  end

  it "should validate presence of password" do
    before = User.count
    user = User.new(name: 'foo', email: 'foobar@foo.bar')
    user.save
    expect(User.count).to eql(before)
  end

  it "should create user" do
    before = User.count
    user = User.new(name: 'foo', email: 'foobar@foo.bar')
    user.generate_password 'nice_password'
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/chevrolet.jpg") do |f|
      user.avatar = f
    end

    user.save
    expect(User.count).to eql(before + 1)

  end

  it "should not create user without avatar" do
    before = User.count
    user = User.new(name: 'foo', email: 'foobar@foo.bar')
    user.generate_password 'nice_password'

    user.save
    expect(User.count).to eql(before)

  end



end
