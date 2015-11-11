require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    first = User.new(name: 'Sanya', last_name: 'Bogomolov', email: 'a.starwars.d@gmail.com')
    first.generate_password 'nice_password'
    first.save

    second = User.new(name: 'Fedor', last_name: 'Tsarenki', email: 'pidor@gmail.com')
    second.generate_password 'nice_password'
    second.save

  end

  it "should get index" do
    get :index
    json = JSON.parse @response.body
    expect(json[0]['name']).to eql('Sanya')
    expect(json[1]['name']).to eql('Fedor')
  end

  it "should get sanya" do
    get :show, {id: 1}
    json = JSON.parse @response.body
    # byebug
    expect(json['name']).to eql('Sanya')
    expect(json['last_name']).to eql('Bogomolov')
  end

  it "should get nothing" do
    get :show, {id: 3}
    json = JSON.parse @response.body
    # byebug
    expect(json['error']).to eql('no such user')
  end

  it "should update user" do
    put :update, {id: 1, user: {name: 'Alexander'}}, format: :json
    json = JSON.parse @response.body
    expect(json['result']).to eql('success')
    expect(User.find(1).name).to eql('Alexander')
  end

  it "should update invalid user" do
    put :update, {id: 3, user: {name: 'Alexander'}}, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql('no such user')
    expect(User.find(1).name).to eql('Sanya')
  end

  it "should not update user" do
    put :update, {id: 1, user: {name: ''}}, format: :json
    json = JSON.parse @response.body
    expect(json['error']).to eql('invalid data')
    expect(User.find(1).name).to eql('Sanya')
  end

  it "should delete user" do
    before = User.count
    delete :destroy, {id: 1}
    json = JSON.parse @response.body
    expect(json['result']).to eql('success')
    expect(User.count).to eql(before - 1)
  end

  it "should not delete user" do
    before = User.count
    delete :destroy, {id: 3}
    json = JSON.parse @response.body
    expect(json['error']).to eql('no such user')
    expect(User.count).to eql(before)
  end

  it "should create user" do
    before = User.count
    post :create, {user: {name: 'Den', last_name: 'Krasava', email: 'notpidor@gmai.com', password: 'great_password', password_confirmation: 'great_password'}}
    json = JSON.parse @response.body
    expect(json['result']).to eql('success')
    expect(User.count).to eql(before + 1)

  end



  it "should not create user" do
    before = User.count
    post :create, {user: {name: '', last_name: 'Krasava', email: 'notpidor@gmai.com', password: 'great_password', password_confirmation: 'great_password'}}
    json = JSON.parse @response.body
    expect(json['error']).to eql('invalid params')
    expect(User.count).to eql(before)
  end

  it "password do not match" do
    before = User.count
    post :create, {user: {name: 'Den', last_name: 'Krasava', email: 'notpidor@gmai.com', password: 'great_password', password_confirmation: 'nice_password'}}
    json = JSON.parse @response.body
    expect(json['error']).to eql('passwords do not match')
    expect(User.count).to eql(before)
  end

  it "invalid password" do
    before = User.count
    post :create, {user: {name: 'Den', last_name: 'Krasava', email: 'notpidor@gmai.com', password: 'foo', password_confirmation: 'foo'}}
    json = JSON.parse @response.body
    expect(json['error']).to eql('invalid password')
    expect(User.count).to eql(before)
  end



end
