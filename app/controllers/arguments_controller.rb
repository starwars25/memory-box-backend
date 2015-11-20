class ArgumentsController < ApplicationController
  before_action :logged_in

  # TO-DO methods:
  #
  # - show - IMPLEMENTED
  # - create
  # - destroy
  # - finish


  def show
    argument = Argument.find_by(id: params[:id])
    if argument
      if argument.users.include?(current_user)
        render json: argument
      else
        render json: {error: 'wrong user'}
      end

    else
      render json: {error: 'no such argument'}
    end
  end

  private

  def logged_in
    render json: {error: 'not logged in'} unless current_user
  end


end
