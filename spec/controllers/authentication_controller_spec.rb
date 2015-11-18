require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  before(:each) do
    clean
    create_users
  end

  it "should authenticate user" do
    post :create, {user:{email: @first.email, password: 'nice_password'}}, format: :json
    json = JSON.parse(@response.body)
    @first.reload
    expect(json['result']).to eql 'success'
    expect(json['token']).not_to eql nil
    expect(json['user_id']).not_to eql nil
    expect(@first.authentication_digest).not_to eql nil

  end

  it "should not authenticate user" do
    post :create, {user:{email: @first.email, password: 'invalid_password'}}, format: :json
    json = JSON.parse(@response.body)
    @first.reload
    expect(json['result']).to eql 'failure'
    expect(json['description']).to eql 'invalid password'
    expect(json['token']).to eql nil
    expect(@first.authentication_digest).to eql nil

  end

  it "should not authenticate non-existing user" do
    post :create, {user:{email: 'invalid@gmail.com', password: 'nice_password'}}, format: :json
    json = JSON.parse(@response.body)
    expect(json['result']).to eql 'failure'
    expect(json['description']).to eql 'no such user'
    @first.reload
    @second.reload
    expect(json['token']).to eql nil
    expect(@first.authentication_digest).to eql nil
    expect(@second.authentication_digest).to eql nil

  end
end
