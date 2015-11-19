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

  it "test update" do
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    put :update, id: @first_box.id, box: {title: 'Another title'}, format: :json
    json = JSON.parse @response.body
    @first_box.reload
    expect(@first_box.title).to eql('Another title')
    expect(json['result']).to eql 'success'


    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    put :update, id: @first_box.id, box: {title: ''}, format: :json
    json = JSON.parse @response.body
    @first_box.reload
    expect(@first_box.title).to eql('Another title')
    expect(json['description']).to eql 'invalid params'

    put :update, id: @second_box.id, box: {title: 'Another title'}, format: :json
    json = JSON.parse @response.body

    @first_box.reload
    expect(@second_box.title).to eql('SecondBox')
    expect(json['description']).to eql 'not a member of the box'

    put :update, id: 100, box: {title: 'Another title'}, format: :json
    json = JSON.parse @response.body

    expect(json['description']).to eql 'no such box'



  end

  it "test destroy" do
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    before = Box.count
    delete :destroy, id: @first_box.id
    json = JSON.parse @response.body
    expect(Box.count).to eql(before - 1)
    expect(json['result']).to eql 'success'

    before = Box.count
    delete :destroy, id: @second_box.id
    json = JSON.parse @response.body
    expect(Box.count).to eql(before)
    expect(json['description']).to eql 'not a member of the box'


    before = Box.count
    delete :destroy, id: 100
    json = JSON.parse @response.body
    expect(Box.count).to eql(before)
    expect(json['description']).to eql 'no such box'
  end

  it "test add user" do
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    before = @first_box.users.count
    user_before = @third.boxes.count
    post :add, id: @first_box.id, box: {users: [@third.id]}
    json = JSON.parse @response.body
    @first_box.reload
    @third.reload
    expect(@third.boxes.count).to eql(user_before + 1)
    expect(@first_box.users.count).to eql(before + 1)
    expect(json['result']).to eql('success')


    # before = @first_box.users.count
    # user_before = @third.boxes.count
    # post :add, id: @first_box.id, box: {users: [@third.id]}
    # json = JSON.parse @response.body
    # @first_box.reload
    # @third.reload
    # expect(@third.boxes.count).to eql(user_before)
    # expect(@first_box.users.count).to eql(before)
    # expect(json['result']).to eql('success')



    before = @second_box.users.count
    user_before = @first.boxes.count
    post :add, id: @second_box.id, box: {users: [@first.id]}
    json = JSON.parse @response.body
    @second_box.reload
    @first.reload
    expect(@first.boxes.count).to eql(user_before)
    expect(@second_box.users.count).to eql(before)
    expect(json['description']).to eql('not a member of the box')

    post :add, id: 1000, box: {users: [@first.id]}
    json = JSON.parse @response.body
    expect(json['description']).to eql 'no such box'



  end



end
