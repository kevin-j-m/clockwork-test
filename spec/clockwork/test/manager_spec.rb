require "spec_helper"
require "clockwork/test/manager"

describe Clockwork::Test::Manager do
  subject(:manager) { Clockwork::Test::Manager.new(opts) }
  let(:opts) { {} }

  context "initial state" do
    its(:total_ticks) { should eq 0 }
    its(:max_ticks) { should be_nil }
    its(:end_time) { should be_nil }

    context "providing a maximum number of ticks" do
      let(:opts) { { max_ticks: max_ticks } }
      let(:max_ticks) { 42 }

      its(:max_ticks) { should eq max_ticks }
    end

    context "providing a time the clock should stop" do
      let(:opts) { { end_time: end_time } }
      let(:end_time) { Time.current }

      its(:end_time) { should eq end_time }
    end
  end

  describe "#run" do
    context "limiting the number of ticks" do
      let(:opts) { { max_ticks: max_ticks } }
      let(:max_ticks) { 1 }

      it "only runs the number of times specified" do
        manager.run
        expect(manager.total_ticks).to eq 1
      end

      context "specifying number of ticks in the method invocation" do
        let(:method_max_ticks) { 3 }

        it "runs the number of times specified in the run call" do
          manager.run(max_ticks: method_max_ticks)
          expect(manager.total_ticks).to eq method_max_ticks
        end
      end
    end

    context "limiting the time the clock should run" do
      let(:opts) { { end_time: end_time } }
      let(:end_time) { Time.current + 2.seconds }

      it "stops running after reaching the end time" do
        manager.run
        expect(Time.current).to be_within(1.second).of(end_time)
        expect(manager.total_ticks).to be > 0
      end

      context "specifying the end time in the method invocation" do
        let(:method_end_time) { Time.current + 4.seconds }

        it "stops running after reaching the end time specified in the call" do
          manager.run(end_time: method_end_time)
          expect(Time.current).to be_within(1.second).of(method_end_time)
          expect(manager.total_ticks).to be > 0
        end
      end

      context "recording job history" do
        let(:opts) { { max_ticks: max_ticks } }
        let(:max_ticks) { 1 }
        let(:job_name) { "Test job" }

        before do
          manager.handler { }
          manager.every(1.minute, job_name)
          manager.run
        end

        it "knows the job has run" do
          expect(manager.ran_job?(job_name)).to be_truthy
        end

        it "finds a single run of the job" do
          expect(manager.times_run(job_name)).to eq 1
        end
      end
    end
  end

  describe "#ran_job?" do
    let(:history) { double("history") }
    let(:job) { double("job") }

    it "determines if the job has run from the job history" do
      allow(manager).to receive(:history).and_return(history)

      expect(history).to receive(:ran_job?).with(job)
      manager.ran_job?(job)
    end
  end

  describe "#times_run" do
    let(:history) { double("history") }
    let(:job) { double("job") }

    it "determines the number of times the job has run from the history" do
      allow(manager).to receive(:history).and_return(history)

      expect(history).to receive(:times_run).with(job)
      manager.times_run(job)
    end
  end
end
