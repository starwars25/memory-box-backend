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

  def recreate_thumbnails
    Argument.find_each do |a|
      begin
        a.video.recreate_versions!
      rescue
        puts a
      end
    end
  end

  def update_test_users
    path = File.dirname(__FILE__)
    path = File.expand_path('../..', path)
    path = File.join(path, '/public/test.mp4')
    File.open(path, 'r') do |f|
      (1..50).each do |i|
        argument = Argument.find_by(id: i)
        if argument
          argument.video = f
          argument.save
        end
      end
    end
  end


end



