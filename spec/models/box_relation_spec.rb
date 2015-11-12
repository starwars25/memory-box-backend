require 'rails_helper'

RSpec.describe BoxRelation, type: :model do
  it "should not create relation without user_id" do
    before = BoxRelation.count
    BoxRelation.create(box_id: 1)
    expect(before).to eql BoxRelation.count
  end

  it "should not create relation without box_id" do
    before = BoxRelation.count
    BoxRelation.create(user_id: 1)
    expect(before).to eql BoxRelation.count
  end

  it "should create box" do
    before = BoxRelation.count
    BoxRelation.create(user_id: 1, box_id: 1)
    expect(before).to eql BoxRelation.count - 1
  end

end
