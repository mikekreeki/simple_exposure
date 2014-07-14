class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  expose(:message) { 'Hello!' }

  expose(:current_user)

  expose(:posts_count) { 0 }

  expose(:nil_value, extend: :decorate)

  def index
    @posts_count = 2
  end

  private

  def current_user
    'mikekreeki'
  end

end
