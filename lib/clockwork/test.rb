require "clockwork"
require "timecop"

require "clockwork/test/event"
require "clockwork/test/job_history"
require "clockwork/test/manager"
require "clockwork/test/version"
require "clockwork/test/rspec/matchers"

module Clockwork
  module Methods
    def every(period, job, options={}, &block)
      ::Clockwork.manager.every(period, job, options, &block)
      ::Clockwork::Test.manager.every(period, job, options, &block)
    end

    def configure(&block)
      ::Clockwork.manager.configure(&block)
      ::Clockwork::Test.manager.configure(&block)
    end

    def handler(&block)
      ::Clockwork.manager.handler(&block)
      ::Clockwork::Test.manager.handler(&block)
    end

    def on(event, options={}, &block)
      ::Clockwork.manager.on(event, options, &block)
      ::Clockwork::Test.manager.on(event, options, &block)
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

        run_opts = {
          max_ticks: opts[:max_ticks],
          start_time: opts[:start_time],
          end_time: opts[:end_time],
          tick_speed: opts[:tick_speed]
        }

        manager.run(run_opts) do
          # TODO parse file rather than loading it
          # and overloading Clockwork::Methods::every
          # and Clockwork::Methods::configure
          load file
        end
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
