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

  def create
    box = Box.find_by(id: params[:argument][:box_id])
    if box
      if box.users.include?(current_user)
        argument = Argument.new(argument_params)
        if argument.save
          render json: {result: 'success'}
        else
          render json: {error: 'invalid params'}
        end
      else
        render json: {error: 'wrong user'}
      end
    else
      render json: {error: 'no such box'}
    end
  end

  private

  def logged_in
    render json: {error: 'not logged in'} unless current_user
  end

  def argument_params
    params.require(:argument).permit(:title, :description, :box_id, :expires)
  end


end
