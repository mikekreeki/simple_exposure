require 'active_support/core_ext/string'
require 'active_support/concern'

module SimpleExposure
  module Core
    extend ActiveSupport::Concern

    UnknownExtension = Class.new(NameError)

    included do
      class_attribute :_exposure_extensions
      class_attribute :_exposure_default_values
      before_render :_apply_exposure_extensions
    end

    def _apply_exposure_extensions
      _exposure_extensions.each do |name, extensions|
        extensions.each do |extension|
          _apply_exposure_extension(name, extension)
        end
      end
    end

    def _apply_exposure_extension(name, extension)
      value = send(name)
      new_value = _exposure_extension_class(extension).apply(value, self)
      send(:"#{name}=", new_value)
    end

    def _exposure_extension_class(extension)
      Extensions.const_get(extension.camelize)
    rescue NameError
      raise UnknownExtension, "Unknown extension: #{extension}"
    end

    module ClassMethods

      def expose(names, options = {}, &block)
        names = Array(names)
        extensions = options.fetch(:extend, [])

        _define_exposure_accessors(names, &block)
        _define_exposure_extensions(names, extensions)
      end

      protected

      def _define_exposure_accessors(names, &block)
        attr_accessor(*names)
        helper_method(*names)
        hide_action(*names)

        if block
          names.each do |name|
            define_method(name) do
              value = instance_variable_get(:"@#{name}")
              return value if value
              send :"#{name}=", instance_eval(&block)
            end
          end
        end
      end

      def _define_exposure_extensions(names, *extensions)
        self._exposure_extensions ||= Hash.new([])
        names.each do |name|
          _exposure_extensions[name] += extensions.flatten
        end
      end
    end
  end
end
