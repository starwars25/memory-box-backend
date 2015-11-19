require 'rails_helper'

RSpec.describe BoxesController, type: :controller do
  before(:each) do
    clean
    create_users
    @token = log_in @first
    create_boxes
  end

  it "should create box" do
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token

    post :create, {box: {title: 'TestBox', users: [@second.id, @third.id]}}, format: :json
    json = JSON.parse @response.body
    expect(json['result']).to eql 'success'
    expect(json['title']).to eql 'TestBox'
    expect(json['members']).to eql [@first.id, @second.id, @third.id]
    @box = Box.last
    count = @box.users.count
    post :remove, id: 100, box: {user_id: @second.id}, format: :json
    json = JSON.parse @response.body

    expect(json['result']).to eql 'failure'
    @box.reload
    expect(@box.users.count).to eql(count)
    count = @box.users.count

    post :remove, id: @box.id, box: {user_id: @second.id}, format: :json
    json = JSON.parse @response.body

    expect(json['result']).to eql 'success'
    @box.reload
    expect(@box.users.count).to eql(count - 1)


  end

  it "should not create box" do

    post :create, {box: {title: 'TestBox', users: [@second.id, @third.id]}}, format: :json
    json = JSON.parse @response.body
    expect(json['description']).to eql 'not logged in'


  end

  it "should get box" do
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    post :show, id: @first_box.id, format: :json
    json = JSON.parse @response.body
    expect(json['title']).to eql @first_box.title

    post :show, id: @second_box.id, format: :json
    json = JSON.parse @response.body
    expect(json['description']).to eql 'not a member of the box'

    post :show, id: 100, format: :json
    json = JSON.parse @response.body
    expect(json['description']).to eql 'no such box'
  end


end
