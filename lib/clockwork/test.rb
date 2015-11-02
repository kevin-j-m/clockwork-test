require "clockwork"

require "clockwork/test/event"
require "clockwork/test/job_history"
require "clockwork/test/manager"
require "clockwork/test/version"

module Clockwork
  module Methods
    def every(period, job, options={}, &block)
      ::Clockwork.manager.every(period, job, options, &block)
      ::Clockwork::Test.manager.every(period, job, options, &block)
    end
  end

  module Test
    class << self
      def included(klass)
        klass.send "include", Methods
        klass.extend Methods

        klass.send "include", ::Clockwork::Methods
        klass.extend ::Clockwork::Methods
      end

      def manager
        @manager ||= Clockwork::Test::Manager.new
      end

      def manager=(manager)
        @manager = manager
      end
    end

    module Methods
      def run(opts = {})
        file = opts[:file] || "./config/clock.rb"
        run_opts = { max_ticks: opts[:max_ticks], end_time: opts[:end_time] }

        # TODO parse file rather than loading it
        # and overloading Clockwork::Methods::every
        load file

        manager.run(run_opts)
      end

      def clear!
        Clockwork::Test.manager = Clockwork::Test::Manager.new
      end

      def ran_job?(job)
        manager.ran_job?(job)
      end

      def times_run(job)
        manager.times_run(job)
      end

      def block_for(job)
        manager.block_for(job)
      end
    end

    extend Methods, ::Clockwork::Methods
  end
end
