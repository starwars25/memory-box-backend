require 'rails_helper'

RSpec.describe Argument, type: :model do
  before(:each) do
    clean
    create_users
    @box = Box.create(title: 'TextBox')
    @box.add_users [@first.id, @second.id]

  end

  it 'should not create argument' do
    before = Argument.count
    Argument.create(description: 'foobar', expires: 1.month.from_now, box_id:1)
    expect(Argument.count).to eql before
  end

  it 'should not create argument' do
    before = Argument.count
    Argument.create(title: 'foobar', expires: 1.month.from_now, box_id:1)
    expect(Argument.count).to eql before
  end

  it 'should not create argument' do
    before = Argument.count
    Argument.create(title: 'foobar', description: 'foobar', box_id:1)
    expect(Argument.count).to eql before
  end

  it 'should not create argument' do
    before = Argument.count
    Argument.create(description: 'foobar', expires: 1.month.from_now, title: 'foobar')
    expect(Argument.count).to eql before
  end

  it 'should create argument' do
    before = Argument.count
    argument = Argument.new(description: 'foobar', expires: 1.month.from_now, title: 'foobar', box_id: 1)
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/Video.mov") do |f|
      argument.video = f
    end
    argument.save
    expect(Argument.count).to eql (before + 1)
    expect(argument.established).not_to eql nil

  end


  it 'should create argument in box' do
    before = Argument.count
    expect(@box.arguments.count).to eql 0
    expect(@first.arguments.count).to eql 0
    expect(@second.arguments.count).to eql 0
    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/Video.mov") do |f|

      @box.add_argument('Foobar', 'Foobar Content', 1.year.from_now, f)

    end
    expect(@box.arguments.count).to eql 1
    expect(@first.arguments.count).to eql 1
    expect(@second.arguments.count).to eql 1
    expect(Argument.first.users.count).to eql 2

    File.open("/Users/admin/Desktop/MemoryBox/spec/controllers/Video.mov") do |f|
      @box.add_argument('', 'Foobar Content', 1.year.from_now, f)
    end

    expect(@box.arguments.count).to eql 1
    expect(@first.arguments.count).to eql 1
    expect(@second.arguments.count).to eql 1

    @box.remove_argument(Argument.first.id)
    expect(@box.arguments.count).to eql 0
    expect(@first.arguments.count).to eql 0
    expect(@second.arguments.count).to eql 0

  end

  it 'should test contains' do
    create_boxes
    create_arguments

    expect(@first_argument.has_user? @first.id).to eql true
    expect(@first_argument.has_user? @third.id).to eql false
  end
end
