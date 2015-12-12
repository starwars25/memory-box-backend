class ArgumentsController < ApplicationController
  before_action :logged_in

  # TO-DO methods:
  #
  # - show - IMPLEMENTED
  # - create - IMPLEMENTED
  # - destroy - IMPLEMENTED
  # - finish


  def show
    argument = Argument.find_by(id: params[:id])
    if argument
      if argument.users.include?(current_user)
        render json: argument, root: false
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
        file = file_decode(params[:argument][:video], 'mov', 'video')
        argument.video = file if file
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

  def destroy
    argument = Argument.find_by(id: params[:id])
    if argument
      if argument.users.include? current_user
        if argument.destroy
          render json: {result: 'success'}
        else
          render json: {error: 'some error happened'}
        end
      else
        render json: {error: 'wrong user'}
      end
    else
      render json: {error: 'no such argument'}
    end
  end

  def finish
    argument = Argument.find_by(id: params[:id])
    if argument
      if argument.users.include? current_user

        argument.update_attribute(:finished, true)
        render json: {result: 'success'}

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

  def argument_params
    params.require(:argument).permit(:title, :description, :box_id, :expires)
  end


end
