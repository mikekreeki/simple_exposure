require 'simple_exposure/extensions/paginate'
require 'simple_exposure/extensions/decorate'

module SimpleExposure
  UnknownExtension = Class.new(NameError)

  module Core
    extend ActiveSupport::Concern

    included do
      delegate :_exposure_extensions, to: :class
      delegate :_exposure_extension_class, to: :class
      before_render :_apply_exposure_extensions
    end

    def _apply_exposure_extensions
      _exposure_extensions.each do |attribute, extensions|
        extensions.each do |extension|
          _apply_exposure_extension(attribute, extension.to_s)
        end
      end
    end

    def _apply_exposure_extension(attribute, extension)
      value = send(attribute)

      unless value.nil?
        extension = _exposure_extension_class(extension)
        send :"#{attribute}=", extension.apply(value, self)
      end
    end

    module ClassMethods

      def expose(*attributes, &block)
        options = attributes.extract_options!

        extensions = options.fetch(:extend, nil)
        extensions = Array(extensions)

        _define_exposure_accessors(attributes, &block)
        _define_exposure_extensions(attributes, extensions)
      end

      def _exposure_extensions
        @_exposure_extensions ||= HashWithIndifferentAccess.new([])
      end

      def _exposure_extension_class(extension)
        Extensions.const_get(extension.camelize)
      rescue NameError
        raise UnknownExtension, "Unknown extension: #{extension}"
      end

      private

      def _define_exposure_accessors(attributes, &block)
        _define_exposure_readers(attributes, &block)
        _define_exposure_writers(attributes)
      end

      def _define_exposure_readers(attributes, &block)
        attributes.each do |attribute|
          _define_exposure_reader(attribute, &block)
        end
      end

      def _define_exposure_reader(attribute, &block)
        if block
          _define_exposure_reader_with_defaults(attribute, &block)
        else
          attr_reader(attribute)
        end

        helper_method(attribute)
        hide_action(attribute)
      end

      def _define_exposure_reader_with_defaults(attribute, &block)
        define_method(attribute) do
          value = instance_variable_get("@#{attribute}")
          return value if value
          send :"#{attribute}=", instance_eval(&block)
        end
      end

      def _define_exposure_writers(attributes)
        attr_writer(*attributes)
      end

      def _define_exposure_extensions(attributes, extensions)
        attributes.each do |attribute|
          _exposure_extensions[attribute] += extensions
        end
      end

      def method_missing(extension, *attributes, &block)
        extension_class = _exposure_extension_class(extension.to_s)
        if extension_class
          options = attributes.extract_options!

          extensions = options.fetch(:extend, nil)
          extensions = Array(extensions)
          extensions = extensions.prepend(extension)

          options = options.merge(extend: extensions)

          expose(*attributes, options, &block)
        end
      rescue UnknownExtension
        super
      end

      def respond_to_missing?(extension, include_private = false)
        _exposure_extension_class(extension.to_s)
      rescue UnknownExtension
        false
      end
    end
  end
end
