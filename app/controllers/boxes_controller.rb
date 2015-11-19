class BoxesController < ApplicationController
  before_action :logged_in

  # noinspection RailsChecklist01
  def create
    box = Box.create(title: params[:box][:title])
    if box
      box.add_users [current_user.id]
      box.add_users params[:box][:users]
      # byebug
      ids = box.users_ids
      render json: {result: 'success', title: box.title, members: ids}
    else
      render json: {result: 'failure', description: 'invalid params'}
    end
  end

  def remove
    box = Box.find_by(id: params[:id])
    if box && box.users_ids.include?(current_user.id)
      box.remove_user(params[:box][:user_id])
      render json: {result: 'success'}
    else
      render json: {result: 'failure', description: 'no such box'}
    end
  end

  def show
    box = Box.find_by(id: params[:id])
    if box
      if box.is_member current_user.id
        render json: box
      else
        render json: {result: 'failure', description: 'not a member of the box'}
      end
    else
      render json: {result: 'failure', description: 'no such box'}
    end
  end

  def update
    box = Box.find_by(id: params[:id])
    if box
      if box.is_member current_user.id
        if box.update(box_params)
          render json: {result: 'success'}
        else
          render json: {result: 'failure', description: 'invalid params'}

        end
      else
        render json: {result: 'failure', description: 'not a member of the box'}
      end

    else
      render json: {result: 'failure', description: 'no such box'}
    end
  end

  def destroy
    box = Box.find_by(id: params[:id])
    if box
      if box.is_member current_user.id
        box.destroy
        render json: {result: 'success'}
      else
        render json: {result: 'failure', description: 'not a member of the box'}
      end

    else
      render json: {result: 'failure', description: 'no such box'}
    end
  end

  def add
    box = Box.find_by(id: params[:id])
    if box
      if box.is_member current_user.id
        box.add_users(params[:box][:users])
        render json: {result: 'success'}
      else
        render json: {result: 'failure', description: 'not a member of the box'}
      end

    else
      render json: {result: 'failure', description: 'no such box'}
    end

  end

  private
  def logged_in
    render json: {result: 'failure', description: 'not logged in'} unless current_user
  end

  def box_params
    params.require(:box).permit(:title)
  end
end
