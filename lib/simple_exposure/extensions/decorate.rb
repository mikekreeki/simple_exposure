module SimpleExposure
  module Extensions
    module Decorate
      extend self

      def apply(value, _)
        value.decorate
      end
    end
  end
end
