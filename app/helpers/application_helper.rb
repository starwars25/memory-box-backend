# noinspection ALL
module ApplicationHelper
  def current_user
    # user = User.where("id = #{request.headers['user-id']}").first
    user = User.find_by(id: request.headers['user-id'])
    # byebug
    if (user && user.authentication_digest)

      if BCrypt::Password.new(user.authentication_digest) == request.headers['token']
        user
      else
        nil
      end
    else
      nil
    end
  end
end
