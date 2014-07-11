require 'simple_exposure/version'
require 'simple_exposure/before_render'
require 'simple_exposure/core'

ActiveSupport.on_load(:action_controller) do
  extend SimpleExposure::BeforeRender
  extend SimpleExposure::Core
end
