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

end
