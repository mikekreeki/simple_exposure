require 'ostruct'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  expose(:message)       { 'Hello!' }
  expose(:other_message) { 'Hello!' }
  expose(:ivar_message)

  expose(:current_user)

  expose(:decoratable_message, extend: :decorate) do
    OpenStruct.new(decorate: 'Hello!')
  end

  expose(:nil_value, extend: :decorate)

  decorate(:other_user) { OpenStruct.new(decorate: 'Andrew Bennett') }

  def index
    self.other_message = 'Other message'
    @ivar_message = 'Hello!'
  end

  private

  def current_user
    'mikekreeki'
  end

end
