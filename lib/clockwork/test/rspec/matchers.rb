require "clockwork/test/rspec/matchers/have_run"

module Clockwork
  module Test
    module RSpec
      module Matchers
        def have_run(job, opts = {})
          Matchers::HaveRun.new(job, opts)
        end
      end
    end
  end
end
