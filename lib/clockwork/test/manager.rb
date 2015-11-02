module Clockwork
  module Test
    require "clockwork"
    require "clockwork/test/job_history"
    require "clockwork/test/event"

    class Manager < Clockwork::Manager
      attr_reader :total_ticks, :max_ticks, :end_time

      def initialize(opts = {})
        super()
        @history = JobHistory.new
        @work_done = {}

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
        work_done[job] || Proc.new {}
      end

      private

      attr_reader :history, :work_done

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
        update_work_done
        history.record(jobs_run_now)
      end

      # TODO: integrate into job history
      def update_work_done
        events_to_run(Time.now).each do |event|
          work_done[event.job] = event.block
        end
      end

      def jobs_run_now
        events_to_run(Time.now).map(&:job)
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
