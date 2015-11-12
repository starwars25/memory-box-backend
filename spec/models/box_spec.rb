require 'rails_helper'

RSpec.describe Box, type: :model do
  it 'should not create box without name' do
    before = Box.count
    Box.create
    expect(before).to eql Box.count
  end

  it 'should not create box with short name' do
    before = Box.count
    Box.create(name: 'foo')
    expect(before).to eql Box.count
  end

  it 'should create box' do
    before = Box.count
    Box.create(name: 'foobar')
    expect(before).to eql Box.count - 1
  end
end
