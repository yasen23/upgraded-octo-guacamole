module Guac
  class ControllerRegistry
      def initialize()
          @controllers = {}
      end

      def add_controllers(controller_hash)
          @controllers.merge! controller_hash
      end

      def get_controller(name)
          @controllers[name]
      end
  end
end
