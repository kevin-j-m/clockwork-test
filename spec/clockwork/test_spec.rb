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

    it "runs the test job in the file" do
      expect(Clockwork::Test.ran_job?(test_job_name)).to be_truthy
    end

    it "knows the job ran a single time" do
      expect(Clockwork::Test.times_run(test_job_name)).to eq 1
    end

    it "retains a record of the work that the job would have done" do
      expect(Clockwork::Test.block_for(test_job_name).call).to eq test_job_output
    end
  end
end
