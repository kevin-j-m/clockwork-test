module Clockwork
  module Test
    class JobHistory
      def initialize(prior_history = {}, prior_work = {})
        @history = prior_history
        @work_done = prior_work
      end

      def jobs
        history.keys
      end

      def ran_job?(job)
        jobs.include?(job)
      end

      def times_run(job)
        history[job] || 0
      end

      def block_for(job)
        work_done[job] || Proc.new {}
      end

      def record(new_events)
        new_events.each do |event|
          job = event.job

          prior_runs = times_run(job)
          history[job] = prior_runs > 0 ? prior_runs + 1 : 1
          work_done[job] = event.block
        end
      end

      private

      attr_reader :history, :work_done
    end
  end
end
