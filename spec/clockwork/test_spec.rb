require "spec_helper"

describe Clockwork::Test do
  let(:clock_file) { "spec/fixtures/clock.rb" }
  let(:test_job_name) { "Run a job" }
  let(:test_job_output) { "Here's a running job" }

  it "has a version number" do
    expect(Clockwork::Test::VERSION).not_to be nil
  end

  describe ".run" do
    before { Clockwork::Test.run(file: clock_file, max_ticks: 1) }
    after { Clockwork::Test.clear! }

    it { should have_run(test_job_name) }
    it { should have_run(test_job_name).exactly(1).time }
    it { should log(test_job_output).for(test_job_name) }
  end
end
