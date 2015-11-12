module Clockwork
  module Test
    module RSpec
      module Matchers
        class HaveRun
          def initialize(job_name = nil, opts = {})
            @job_name = job_name
            @times_run = opts[:times] || 1
            @exactly = false
          end

          def matches?(clock_test)
            if @exactly
              clock_test.manager.times_run(@job_name) == @times_run
            else
              clock_test.manager.ran_job?(@job_name)
            end
          end

          def once
            @times_run = 1
            @exactly = true

            self
          end

          def exactly(times)
            @times_run = times
            @exactly = true

            self
          end

          def times(times = nil)
            if times
              @times_run = times
              @exactly = true
            end

            self
          end

          def time(times = nil)
            if times
              @times_run = times
              @exactly = true
            end

            self
          end

          def description
            "run \"#{@job_name}\" #{@times_run} #{@times_run == 1 ? 'time' : 'times'}"
          end

          def failure_message
            "expected Clockwork::Test to have " + description
          end

          def failure_message_when_negated
            "expected Clockwork::Test to not have run \"#{@job_name}\"."
          end
        end
      end
    end
  end
end
