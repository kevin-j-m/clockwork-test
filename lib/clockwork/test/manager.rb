module Clockwork
  module Test
    class Manager < Clockwork::Manager
      attr_reader :total_ticks, :max_ticks, :end_time, :start_time

      def initialize(opts = {})
        super()
        @history = JobHistory.new
        @total_ticks = 0
        set_opts(opts)

        config[:logger].level = Logger::ERROR
      end

      def run(opts = {})
        set_opts(opts)

        run_block = proc do
          yield if block_given?
          tick_loop
        end

        if start_time
          Timecop.travel(start_time, &run_block)
        else
          run_block.call
        end
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

      def set_opts(opts)
        @max_ticks = opts[:max_ticks] if opts[:max_ticks]
        @start_time = opts[:start_time] if opts[:start_time]
        if opts[:end_time]
          @end_time = opts[:end_time]
        elsif @start_time
          @end_time = Time.current
        end
        @tick_speed = opts[:tick_speed]

        raise "End time can't precede start time." if @start_time && (@start_time > @end_time)
      end

      attr_reader :history

      def tick_loop
        loop.with_index do |_, index|
          Timecop.travel(Time.current + @tick_speed.to_i * index) do
            return if ticks_exceeded? || (time_exceeded? && index > 0)

            update_job_history
            tick
            @total_ticks += 1
          end
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
