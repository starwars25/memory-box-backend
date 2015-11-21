require 'rails_helper'

RSpec.describe ArgumentsController, type: :controller do
  before(:all) do
    clean
    create_users
    create_boxes
    create_arguments
  end

  it "test show" do
    # not logged in

    get :show, id: @first_argument.id, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql 'not logged in'

    # invalid user
    @token = log_in @third
    @request.headers['user-id'] = @third.id
    @request.headers['token'] = @token
    get :show, id: @first_argument.id, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql 'wrong user'

    # correct user

    @token = log_in @first
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    get :show, id: @first_argument.id, format: :json
    json = JSON.parse @response.body
    expect(json['id']).to eql @first_argument.id
    expect(json['title']).to eql @first_argument.title
    expect(json['description']).to eql @first_argument.description

    # invalid argument id

    @token = log_in @first
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    get :show, id: 100, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql 'no such argument'

  end

  it "test create" do
    # not logged in

    post :create, argument: {title: 'Title', description: 'Description', expires: 14.days.from_now, box_id: @first_box.id}, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql 'not logged in'


    # not a member of box

    @token = log_in @third
    @request.headers['user-id'] = @third.id
    @request.headers['token'] = @token
    post :create, argument: {title: 'Title', description: 'Description', expires: 14.days.from_now, box_id: @first_box.id}, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql 'wrong user'

    # invalid params

    @token = log_in @first
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    post :create, argument: {description: 'Description', expires: 14.days.from_now, box_id: @first_box.id}, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql 'invalid params'

    # no such box

    @token = log_in @first
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    post :create, argument: {title: 'Title', description: 'Description', expires: 14.days.from_now, box_id: 100}, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql 'no such box'

    # successful

    @token = log_in @first
    @request.headers['user-id'] = @first.id
    @request.headers['token'] = @token
    before_first_user = @first.arguments.count
    before_second_user = @second.arguments.count
    before_first_box = @first_box.arguments.count
    post :create, argument: {title: 'Title', description: 'Description', expires: 14.days.from_now, box_id: @first_box.id}, format: :json
    json = JSON.parse @response.body
    expect(json['result']).to eql 'success'
    @first.reload
    @second.reload
    @first_box.reload

    expect(@first.arguments.count).to eql(before_first_user + 1)
    expect(@second.arguments.count).to eql(before_second_user + 1)
    expect(@first_box.arguments.count).to eql(before_first_box + 1)
  end

end
