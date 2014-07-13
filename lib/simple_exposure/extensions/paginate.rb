module SimpleExposure
  module Extensions
    module Paginate
      extend self

      def apply(value, controller)
        value.page controller.params[:page]
      end
    end
  end
end
