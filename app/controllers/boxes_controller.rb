class BoxesController < ApplicationController
  before_action :logged_in

  # noinspection RailsChecklist01
  def create
    box = Box.create(title: params[:box][:title])
    if box
      box.add_users [current_user.id]
      box.add_users params[:box][:users]
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



  private
  def logged_in
    render json: {result: 'failure', description: 'not logged in'} unless current_user
  end
end
