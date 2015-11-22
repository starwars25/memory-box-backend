module StaticHelper
  def current_developer
    session['logged_in'] == true
  end
end
