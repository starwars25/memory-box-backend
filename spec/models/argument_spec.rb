require 'rails_helper'

RSpec.describe Argument, type: :model do
  before(:each) do
    clean
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
end
