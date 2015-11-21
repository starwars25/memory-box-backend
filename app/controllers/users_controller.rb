class UsersController < ApplicationController
  before_action :logged_in, only: [:update, :destroy, :show]
  before_action :correct_user, only: [:update, :destroy]
  def index
    render json: User.all
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user
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

  private
  def user_params
    params.require(:user).permit(:name, :last_name, :email)
  end



  def logged_in
    render json: {result: 'failure', description: 'not logged in'} unless current_user
  end

  def correct_user
    render json: {result: 'failure', description: 'wrong user'} unless current_user.id == params[:id].to_i
  end




end
