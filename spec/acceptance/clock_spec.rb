require "spec_helper"

describe "Clockwork" do
  let(:clock_file) { "spec/fixtures/clock.rb" }
  let(:test_job_name) { "Run a job" }

  after(:each) { Clockwork::Test.clear! }

  describe "Run a job" do
    before { Clockwork::Test.run(file: clock_file, max_ticks: 1) }

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

  describe "Custom matchers" do
    subject(:clockwork) { Clockwork::Test }

    before { Clockwork::Test.run(file: clock_file, max_ticks: 1) }

    it { should have_run(test_job_name) }
    it { should have_run(test_job_name).once }

    it { should_not have_run(test_job_name).exactly(2).times }

    it "works as an explicit expectation as well" do
      expect(Clockwork::Test).to have_run(test_job_name)
      expect(Clockwork::Test).to_not have_run(test_job_name).exactly(2).times
    end

    context "running multiple times" do
      before { Clockwork::Test.run(file: clock_file, max_ticks: 2, tick_speed: 1.minute) }

      it { should have_run(test_job_name).exactly(2).times }
      it { should have_run(test_job_name) }
      it { should have_run(test_job_name).times(2) }
      it { should have_run(test_job_name).exactly(2) }
      it { should have_run(test_job_name, times: 2) }
    end
  end

  describe "Run at certain time" do
    subject(:clockwork) { Clockwork::Test }

    before(:each) do
      Time.zone = time_zone

      Clockwork::Test.run(clock_opts)
    end

    after(:each) { Clockwork::Test.clear! }

    let(:clock_opts) { { file: clock_file, start_time: start_time, max_ticks: 1 } }

    let(:time_zone) { "US/Eastern" }
    let(:start_time) { Time.zone.local(2008, 9, 1, 17, 30, 0) }

    it { should have_run("Run at certain time").once }

    context "before the job should be run" do
      let(:start_time) { Time.zone.local(2015, 9, 13, 17, 29, 59) }

      it { should_not have_run("Run at certain time") }
    end

    context "after the job should be run" do
      let(:start_time) { Time.zone.local(2015, 9, 13, 17, 31, 0) }

      it { should_not have_run("Run at certain time") }
    end
  end
end
