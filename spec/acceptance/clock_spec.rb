require "spec_helper"

describe "Clockwork" do
  let(:clock_file) { "spec/fixtures/clock.rb" }

  describe "Run a job" do
    let(:test_job_name) { "Run a job" }

    before { Clockwork::Test.run(file: clock_file, max_ticks: 1) }
    after { Clockwork::Test.clear! }

    it "runs the test job in the file" do
      expect(Clockwork::Test.ran_job?(test_job_name)).to be_truthy
    end

    it "knows the job ran a single time" do
      expect(Clockwork::Test.times_run(test_job_name)).to eq 1
    end

    it "retains a record of the work that the job would have done" do
      expect(Clockwork::Test.block_for(test_job_name).call).to eq "Here's a running job"
    end
  end
end
