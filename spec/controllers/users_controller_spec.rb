require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:all) do
    clean
    create_users
    @token = log_in @first

  end

  it "should get index" do
    get :index
    json = JSON.parse @response.body
    expect(json[0]['name']).to eql(@first.name)

    expect(json[1]['name']).to eql(@second.name)
  end

  it "should get sanya" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id

    get :show, {id: @first.id}
    json = JSON.parse @response.body
    expect(json['name']).to eql(@first.name)
  end

  it "should get nothing" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    get :show, {id: 4}
    json = JSON.parse @response.body
    expect(json['error']).to eql('no such user')
  end

  it "should update user" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    put :update, {id: @first.id, user: {name: 'Alexander'}}, format: :json
    json = JSON.parse @response.body
    expect(json['result']).to eql('success')
    expect(User.find(@first.id).name).to eql('Alexander')
  end

  it "should not update user cause wrong user" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    put :update, {id: @second.id, user: {name: 'Alexander'}}, format: :json
    json = JSON.parse @response.body
    expect(json['description']).to eql('wrong user')
  end

  it "should not update user cause not logged in" do
    put :update, {id: @first.id, user: {name: 'Alexander'}}, format: :json
    json = JSON.parse @response.body
    expect(json['description']).to eql('not logged in')
  end

  it "should update invalid user" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    put :update, {id: 3, user: {name: 'Alexander'}}, format: :json
    json = JSON.parse @response.body
    expect(json['description']).to eql('wrong user')
    expect(User.find(@first.id).name).to eql(@first.name)
  end

  it "should not update user" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    name = @first.name
    put :update, {id: @first.id, user: {name: ''}}, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql('invalid data')
    expect(User.find(@first.id).name).to eql(name)
  end



  it "should delete user" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    before = User.count
    delete :destroy, {id: @first.id}
    json = JSON.parse @response.body
    expect(json['result']).to eql('success')
    expect(User.count).to eql(before - 1)
  end

  it "should not delete user" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    before = User.count
    delete :destroy, {id: 3}
    json = JSON.parse @response.body
    expect(json['description']).to eql('wrong user')
    expect(User.count).to eql(before)
  end

  it "should not delete user" do
    @request.headers['token'] = @token
    @request.headers['user-id'] = @first.id
    before = User.count
    delete :destroy, {id: @second.id}
    json = JSON.parse @response.body
    expect(json['description']).to eql('wrong user')
    expect(User.count).to eql(before)
  end

  it "should create user" do
    before = User.count
    photo = File.read(File.expand_path("spec/controllers/chevrolet.jpg"))
    string = Base64.encode64 photo
    post :create, {user: {name: 'Den Krasava', email: 'notpidor@gmai.com', password: 'great_password', password_confirmation: 'great_password', avatar: string}}

    json = JSON.parse @response.body
    expect(json['result']).to eql('success')
    expect(User.count).to eql(before + 1)
    expect(User.last.avatar.url).not_to eql nil
  end

  it "should not create user without photo" do
    before = User.count

    post :create, {user: {name: 'Roma', email: 'notpidor@gmai.com', password: 'great_password', password_confirmation: 'great_password'}}
    json = JSON.parse @response.body
    expect(json['error']).to eql('invalid params')
    expect(User.count).to eql(before)
  end




  it "should not create user" do
    before = User.count
    post :create, {user: {name: '', email: 'notpidor@gmai.com', password: 'great_password', password_confirmation: 'great_password'}}
    json = JSON.parse @response.body
    expect(json['error']).to eql('invalid params')
    expect(User.count).to eql(before)
  end

  it "password do not match" do
    before = User.count
    post :create, {user: {name: 'Den Krasava', email: 'notpidor@gmai.com', password: 'great_password', password_confirmation: 'nice_password'}}
    json = JSON.parse @response.body
    expect(json['error']).to eql('passwords do not match')
    expect(User.count).to eql(before)
  end

  it "invalid password" do
    before = User.count
    post :create, {user: {name: 'Den Krasava', email: 'notpidor@gmai.com', password: 'foo', password_confirmation: 'foo'}}
    json = JSON.parse @response.body
    expect(json['error']).to eql('invalid password')
    expect(User.count).to eql(before)
  end

  it "should post valid token" do

  end




end
