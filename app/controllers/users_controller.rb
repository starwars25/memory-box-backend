class UsersController < ApplicationController
  before_action :logged_in, only: [:update, :destroy, :changes]
  before_action :correct_user, only: [:update, :destroy]
  def index
    @users = User.all
    render json: @users, :each_serializer => UserNotLoggedInSerializer, :root => false
  end

  def show
    user = User.find_by(id: params[:id])
    # byebug
    if user
      if current_user && current_user.id == params[:id].to_i
        render json: user, :serializer => UserSerializer, :root => false
      else
        render json: user, :serializer => UserNotLoggedInSerializer, :root => false

      end
    else
      render json: {error: 'no such user'}
    end
  end

  def update

    user = User.find_by(id: params[:id])
    if user
      if user.update_attributes(user_params)
        render json: {result: 'success'}
      else
        render json: {error: 'invalid data'}
      end
    else
      render json: {error: 'no such user'}
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user
      user.destroy
      render json: {result: 'success'}
    else
      render json: {error: 'no such user'}
    end
  end

  def create
    if params[:user][:password] != params[:user][:password_confirmation]
      render json: {error: 'passwords do not match'}
      return
    end
    user = User.new(user_params)
    file = file_decode(params[:user][:avatar], 'png', 'image/png')
    user.avatar = file if file
    begin
      user.generate_password(params[:user][:password])
    rescue
      render json: {error: 'invalid password'}
      return
    end
    if user.save
      render json: {result: 'success'}

    else
      render json: {error: 'invalid params'}
    end


  end

  def changes
    user = User.find_by(id: params[:id])
    if user
      if user.id == current_user.id
        render json: {changes: user.changes_after?(params[:time])}
      else
        render json: {error: 'wrong user'}
      end
    else
      render json: {error: 'no such user'}
    end
  end

  def token
    byebug
    user = User.find_by(id: params[:id])
    if user
      render json: {result: user.token_valid?(params[:token])}

    else
      render json: {result: 'failure', description: 'no such user'}
    end
  end


  

  private
  def user_params
    params.require(:user).permit(:name, :email, :date_of_birth)
  end



  def logged_in
    byebug
    render json: {result: 'failure', description: 'not logged in'} unless current_user
  end

  def correct_user
    render json: {result: 'failure', description: 'wrong user'} unless current_user.id == params[:id].to_i
  end






end
