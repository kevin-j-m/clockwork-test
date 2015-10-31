module Clockwork
  module Test
    class JobHistory
      def initialize(prior_history = {})
        @history = prior_history
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

      def record(new_jobs)
        new_jobs.each do |job|
          prior_runs = times_run(job)
          history[job] = prior_runs > 0 ? prior_runs + 1 : 1
        end
      end

      private

      attr_reader :history
    end
  end
end
