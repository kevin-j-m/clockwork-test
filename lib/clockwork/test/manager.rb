module Clockwork
  module Test
    require 'clockwork'

    class Manager < Clockwork::Manager
      attr_reader :total_ticks, :max_ticks, :end_time

      def initialize(opts = {})
        super()
        @total_ticks = 0
        @max_ticks = opts[:max_ticks]
        @end_time = opts[:end_time]
        config[:logger].level = Logger::ERROR
      end

      private

      def loop(&block)
        while 1 == 1 do
          block.call

          @total_ticks += 1
          break if ticks_exceeded? || time_exceeded?
        end
      end

      def ticks_exceeded?
        max_ticks && total_ticks >= max_ticks
      end

      def time_exceeded?
        end_time && Time.now >= end_time
      end
    end
  end
end
