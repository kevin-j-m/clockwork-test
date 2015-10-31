require "spec_helper"

describe Clockwork::Test::JobHistory do
  subject(:history) { Clockwork::Test::JobHistory.new(prior_history) }
  let(:prior_history) { {} }

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

  describe "#record" do
    let(:jobs) { [first_job, second_job] }
    let(:first_job) { "job1" }
    let(:second_job) { "job2" }

    it "keeps a record of the job occurring" do
      history.record(jobs)

      expect(history.jobs).to include first_job, second_job
    end

    context "recording jobs that already ran" do
      let(:prior_history) { { "#{first_job}" => 1 } }

      it "increments the counter of the job already recording and adds a new entry for the job never recorded prior" do
        history.record(jobs)

        expect(history.times_run(first_job)).to eq 2
        expect(history.times_run(second_job)).to eq 1
      end
    end
  end
end
