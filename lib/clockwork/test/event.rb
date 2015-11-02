module Clockwork
  module Test
    require "clockwork"

    class Event < Clockwork::Event
      attr_reader :block

      private

      def execute
      end
    end
  end
end
