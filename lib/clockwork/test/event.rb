module Clockwork
  module Test
    class Event < Clockwork::Event
      attr_reader :block

      private

      def execute
      end
    end
  end
end
