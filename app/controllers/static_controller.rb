class StaticController < ApplicationController
  include StaticHelper
  before_action :is_developer, only: [:index]
  before_action :already_developer, only: [:login, :sign_in]

  def index

  end

  def sign_in

  end

  def login
    if params[:session][:password] == 'MemoryBox'
      session['logged_in'] = true
      redirect_to root_url
    else
      render 'static/sign_in'
    end
  end

  def angular
    
  end

  def is_developer
    redirect_to login_path unless current_developer
  end

  def already_developer
    redirect_to root_url if current_developer
  end


end
