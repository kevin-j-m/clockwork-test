require "spec_helper"
require "clockwork/test/job_history"

describe Clockwork::Test::JobHistory do
  subject(:history) { Clockwork::Test::JobHistory.new(prior_history, prior_work) }
  let(:prior_history) { {} }
  let(:prior_work) { {} }

  describe "#jobs" do
    let(:prior_history) do
      {
        "#{first_job}" => 1,
        "#{second_job}" => 1
      }
    end

    let(:first_job) { "job1" }
    let(:second_job) { "job2" }

    its(:jobs) { should include first_job, second_job }
  end

  describe "#ran_job?" do
    let(:prior_history) { { "#{first_job}" => 1 } }
    let(:first_job) { "job1" }
    let(:second_job) { "job2" }

    it "finds history of a job that ran" do
      expect(history.ran_job?(first_job)).to be_truthy
    end

    it "does not find history of a job never run" do
      expect(history.ran_job?(second_job)).to be_falsey
    end
  end

  describe "#times_run" do
    let(:prior_history) { { "#{first_job}" => number_of_first_job_runs } }
    let(:first_job) { "job1" }
    let(:number_of_first_job_runs) { 42 }
    let(:second_job) { "job2" }

    it "finds the number of times a previously job has run" do
      expect(history.times_run(first_job)).to eq number_of_first_job_runs
    end

    it "finds no runs for a job it has no history of" do
      expect(history.times_run(second_job)).to eq 0
    end
  end

  describe "#block_for" do
    let(:prior_work) { { "#{job}" => block } }
    let(:job) { "job" }
    let(:block) { Proc.new { "Running #{job}" } }

    it "recalls the block that was run for a previously run job" do
      expect(history.block_for(job).call).to eq "Running #{job}"
    end

    it "does nothing for a job that was not run" do
      expect(history.block_for("not_run").call).to be_nil
    end
  end

  describe "#record" do
    let(:events) { [first_event, second_event] }

    let(:first_event) { double(job: first_job, block: first_block) }
    let(:first_job) { "job1" }
    let(:first_block) { Proc.new { "Running #{first_job}" } }

    let(:second_event) { double(job: second_job, block: second_block) }
    let(:second_job) { "job2" }
    let(:second_block) { Proc.new {} }

    before { history.record(events) }

    it "keeps a record of the job occurring" do
      expect(history.jobs).to include first_job, second_job
    end

    it "knows the work the job would perform" do
      expect(history.block_for(first_job).call).to eq "Running #{first_job}"
    end

    context "recording jobs that already ran" do
      let(:prior_history) { { "#{first_job}" => 1 } }

      it "increments the counter of the job already recording and adds a new entry for the job never recorded prior" do
        expect(history.times_run(first_job)).to eq 2
        expect(history.times_run(second_job)).to eq 1
      end
    end
  end
end
