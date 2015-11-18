require 'rails_helper'

RSpec.describe Box, type: :model do
  before(:each) do
    # create_users
    clean
    create_users
  end

  it 'should not create box without name' do
    before = Box.count
    Box.create

    expect(before).to eql Box.count
  end

  it 'should not create box with short name' do
    before = Box.count
    Box.create(title: 'foo')
    expect(before).to eql Box.count
  end

  it 'should create box' do
    before = Box.count
    box = Box.create(title: 'foobar')
    expect(before).to eql Box.count - 1
    expect(box.date_of_establishment).not_to eql nil
  end

  it 'should add users' do
    before_relations = BoxRelation.count

    expect(@first.boxes.count).to eql 0
    expect(@second.boxes.count).to eql 0

    box = Box.create(title: 'Test box')
    expect(box.users.count).to eql 0
    box.add_users([@first.id, @second.id])
    expect(BoxRelation.count).to eql (before_relations + 2)
    expect(box.users.count).to eql 2
    expect(@first.boxes.count).to eql 1
    expect(@second.boxes.count).to eql 1
  end

  it 'should add users' do
    before_relations = BoxRelation.count

    expect(@first.boxes.count).to eql 0
    expect(@second.boxes.count).to eql 0

    box = Box.create(title: 'Test box')
    expect(box.users.count).to eql 0
    box.add_users([@first.id, 3])
    expect(BoxRelation.count).to eql (before_relations + 1)
    expect(box.users.count).to eql 1
    expect(@first.boxes.count).to eql 1
    expect(@second.boxes.count).to eql 0
  end

  it 'should remove user from box' do
    before_relations = BoxRelation.count

    expect(@first.boxes.count).to eql 0
    expect(@second.boxes.count).to eql 0

    box = Box.create(title: 'Test box')
    expect(box.users.count).to eql 0
    box.add_users([@first.id, @second.id])
    expect(BoxRelation.count).to eql (before_relations + 2)
    expect(box.users.count).to eql 2
    expect(@first.boxes.count).to eql 1
    expect(@second.boxes.count).to eql 1
    box.remove_user(@second.id)
    expect(box.users.count).to eql 1
    expect(@second.boxes.count).to eql 0

    #remove non existing user
    box.remove_user(3)
    expect(box.users.count).to eql 1
    expect(@second.boxes.count).to eql 0

  end


end
