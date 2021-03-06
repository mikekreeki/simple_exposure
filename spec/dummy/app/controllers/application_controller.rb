require 'ostruct'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  expose(:my_name, :your_name) { 'Jane Doe' }

  expose(:message)       { 'Hello!' }
  expose(:other_message) { 'Hello!' }
  expose(:ivar_message)

  expose(:current_user)

  expose(:decoratable_message, extend: :decorate) do
    OpenStruct.new(decorate: 'Hello!')
  end

  expose(:nil_value, extend: :decorate)

  decorate(:second_user, :third_user) { OpenStruct.new(decorate: 'Andrew Bennett') }

  paginate :combined_extension, extend: :decorate do
    Class.new do
      def page(*)
        @name = 'Hello'
        self
      end

      def decorate
        @name.upcase
      end
    end.new
  end

  def index
    self.other_message = 'Other message'
    @ivar_message = 'Hello!'
  end

  private

  def current_user
    'mikekreeki'
  end

end
