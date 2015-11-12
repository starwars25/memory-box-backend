require 'rails_helper'

RSpec.describe Argument, type: :model do
  before(:each) do
    clean
    create_users
    @box = Box.create(name: 'TextBox')
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
    Argument.create(description: 'foobar', expires: 1.month.from_now, title: 'foobar', box_id: 1)
    expect(Argument.count).to eql (before + 1)

  end

  it 'should create argument in box' do
    before = Argument.count
    expect(@box.arguments.count).to eql 0
    expect(@first.arguments.count).to eql 0
    expect(@second.arguments.count).to eql 0
    @box.add_argument('Foobar', 'Foobar Content', 1.year.from_now)
    expect(@box.arguments.count).to eql 1
    expect(@first.arguments.count).to eql 1
    expect(@second.arguments.count).to eql 1
    expect(Argument.first.users.count).to eql 2


    @box.add_argument('', 'Foobar Content', 1.year.from_now)
    expect(@box.arguments.count).to eql 1
    expect(@first.arguments.count).to eql 1
    expect(@second.arguments.count).to eql 1

    @box.remove_argument(Argument.first.id)
    expect(@box.arguments.count).to eql 0
    expect(@first.arguments.count).to eql 0
    expect(@second.arguments.count).to eql 0

  end
end
