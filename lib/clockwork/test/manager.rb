module Clockwork
  module Test
    class Manager < Clockwork::Manager
      attr_reader :total_ticks, :max_ticks, :end_time

      def initialize(opts = {})
        super()
        @history = JobHistory.new

        @total_ticks = 0
        @max_ticks = opts[:max_ticks]
        @end_time = opts[:end_time]
        config[:logger].level = Logger::ERROR
      end

      def run(opts = {})
        @max_ticks = opts[:max_ticks] if opts[:max_ticks]
        @end_time = opts[:end_time] if opts[:end_time]
        super()
      end

      def ran_job?(job)
        history.ran_job?(job)
      end

      def times_run(job)
        history.times_run(job)
      end

      def block_for(job)
        history.block_for(job)
      end

      private

      attr_reader :history

      def loop(&block)
        while 1 == 1 do
          update_job_history

          block.call

          @total_ticks += 1
          break if ticks_exceeded? || time_exceeded?
        end
      end

      def register(period, job, block, options)
        event = ::Clockwork::Test::Event.new(self, period, job, block || handler, options)
        @events << event
        event
      end

      def update_job_history
        history.record(events_run_now)
      end

      def events_run_now
        events_to_run(Time.now)
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
