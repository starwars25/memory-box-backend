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
        render json: {error: 'wrong user'}, status: :forbidden
      end

    else
      render json: {error: 'no such argument'}, status: :not_found
    end
  end

  def create
    box = Box.find_by(id: params[:argument][:box_id])
    if box
      if box.users.include?(current_user)
        argument = Argument.new(argument_params)
        if argument.save
          render json: {result: 'success', id: argument.id}, status: :created
        else
          render json: {error: 'invalid params'}, status: :bad_request
        end
      else
        render json: {error: 'wrong user'}, status: :forbidden
      end
    else
      render json: {error: 'no such box'}, status: :not_found
    end
  end

  def destroy
    argument = Argument.find_by(id: params[:id])
    if argument
      if argument.users.include? current_user
        if argument.destroy
          render json: {result: 'success'}
        else
          render json: {error: 'some error happened'}, status: :internal_server_error
        end
      else
        render json: {error: 'wrong user'}, status: :forbidden
      end
    else
      render json: {error: 'no such argument'}, status: :not_found
    end
  end

  def finish
    argument = Argument.find_by(id: params[:id])
    if argument
      if argument.users.include? current_user

        argument.update_attribute(:finished, true)
        render json: {result: 'success'}

      else
        render json: {error: 'wrong user'}, status: :forbidden
      end
    else
      render json: {error: 'no such argument'}, status: :not_found
    end
  end

  def upload
    argument = Argument.find_by(id: request.headers['argument-id'])
    if argument
      if argument.has_user? current_user.id
        if argument.activated
          render json: {error: 'already has video'}, status: :forbidden
        else
          tempfile = Tempfile.new('video_upload')
          tempfile.binmode
          tempfile << request.body.read
          tempfile.rewind
          filename = "#{SecureRandom.urlsafe_base64}.mp4"
          video_params = {filename: filename, tempfile: tempfile}
          video = ActionDispatch::Http::UploadedFile.new(video_params)
          argument = Argument.find(request.headers['argument-id'])
          argument.video = video
          argument.activated = true
          argument.save
          render json: {result: 'success'}

        end
      else

        render json: {error: 'wrong user'}, status: :forbidden

      end

    else
      render json: {error: 'no such argument'}, status: :not_found
    end

  end

  private

  def logged_in
    render json: {error: 'not logged in'}, status: :unauthorized unless current_user
  end

  def argument_params
    params.require(:argument).permit(:title, :description, :box_id, :expires)
  end


end
