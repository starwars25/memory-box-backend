class AuthenticationController < ApplicationController
  def create
    user = User.find_by(email: params[:user][:email])
    if user
      if BCrypt::Password.new(user.password_digest) == params[:user][:password]
        user.generate_auth_digest
        render json: {result: 'success', token: user.auth_token, user_id:user.id}
      else
        render json: {result: 'failure', description: 'invalid password'}
      end
    else
      render json: {result: 'failure', description: 'no such user'}
    end
  end
end
