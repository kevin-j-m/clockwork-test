# Clockwork::Test

[![Build Status](https://travis-ci.org/kevin-j-m/clockwork-test.svg?branch=master)](https://travis-ci.org/kevin-j-m/clockwork-test)

[Clockwork](https://rubygems.org/gems/clockwork) is a scheduler process for running scheduled jobs. These scheduled jobs are likely of critical importance to your application. You need to ensure that the jobs run when they should, as often as they should, and with the proper behavior when run.

`Clockwork::Test` includes additional functionality that makes testing of your `clock.rb` file easy. This gem can help make sure that you have scheduled your events appropriately, including testing `if:` or `at:` conditions, as well as allowing you to run assertions against the code that is executed when a job is run.

`Clockwork::Test` has been verified against the latest release of clockwork at the time of its development, which is version 1.2.0. It does not require any specific test framework to be used with it, though all examples will use `rspec`.

## Installation

Add this to your application's Gemfile:

```ruby
group :test do
  gem 'clockwork-test'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clockwork-test

## Example Tests

Given the following `clock.rb` file:

```ruby
require "clockwork"

module Clockwork
  configure do |config|
    config[:tz] = "US/Eastern"
  end

  handler { |job| logger.info "Running #{job}" }

  every(1.minute, "Run a job") do
    "Here's a running job"
  end
end
```

The following tests may be run against it:

```ruby
describe Clockwork do
  after(:each) { Clockwork::Test.clear! }

  it "runs the job once" do
    Clockwork::Test.run(max_ticks: 1)

    expect(Clockwork::Test.ran_job?("Run a job")).to be_truthy
    expect(Clockwork::Test.times_run("Run a job")).to eq 1
    expect(Clockwork::Test.block_for("Run a job").call).to eq "Here's a running job"
  end

  it "runs the job every minute over the course of an hour" do
    start_time = Time.new(2015, 11, 2, 2, 0, 0)
    end_time = Time.new(2015, 11, 2, 3, 0, 0)

    Clockwork::Test.run(start_time: start_time, end_time: end_time, tick_speed:
1.minute)

    expect(Clockwork::Test.times_run("Run a job").to eq 60
  end

  describe "RSpec Custom Matcher" do
    subject(:clockwork) { Clockwork::Test }

    before { Clockwork::Test.run(max_ticks: 1) }

    it { should have_run("Run a job") }
    it { should have_run("Run a job").once }

    it { should_not have_run("Run a job").exactly(2).times }
  end
end
```

## Usage

Replacing any calls to `Clockwork` with `Clockwork::Test` in your tests should perform as expected, with the one caveat that a job running in `Clockwork::Test` will not actually execute its event's handler code. That is suppressed, but made available via the `block_for` method.

### Running Clockwork in Tests

A call to `Clockwork.run` will run the clockwork process until it is signaled to stop, such as by receiving the `SIGINT` signal. `Clockwork::Test.run` provides two ways to easily stop the current execution:

1. After a particular number of clock ticks (See the `max_ticks` configuration setting).
3. After a moment in time has been reached (See the `end_time` configuration setting).

Either of these methods can be used by passing the proper configuration option into the `run` method of `Clockwork::Test`. If both are provided, whichever occurs first will be used to halt execution.

### Configuration Settings

#### max_ticks

Setting the `max_ticks` will determine the number of times that clockwork will run any events scheduled at that time. This is commonly used to let clockwork execute once, to then see if particular jobs are triggered right when clockwork starts up.

#### start_time

This is the time that you would like the clock file to start processing it. This may be used with either the `max_ticks` or `end_time` option to halt execution of the run loop.

If the `start_time` option is used, `Time.now` will be modified to the `start_time` at the beginning of execution of `Clockwork::Test.run`, and will be returned to the proper time at the conclusion of the run.

#### end_time

This specifies the time at which execution of clockwork should terminate. The run loop will continue until the `end_time` is reached, provided the `max_ticks` has not been exceeded, if that is provided.

This is commonly used along with `start_time` and `tick_speed` to quickly see if jobs run as often as expected over a certain period of time.

#### tick_speed

`tick_speed` should be provided as a unit of time, such as `1.minute` or `3.hours`. It is the amount of time that the test will progress time to on every subsequent clock tick.

If `tick_speed` is set to `1.minute` and the current time is `13:00`, the first tick will occur at `13:00`, and the second will appear occur at `13:01`.

This can be used in concert with `start_time` and `end_time` to quickly simulate moving across a large period of time, without having to wait for the full time period to occur in reality.

Note that `tick_speed` should not be set any higher than the minimum amount of granularity used in the clock file under test. Should the `tick_speed` be set to a higher amount, the number of times a job is run, or if the job is run at all, is subject to inconsistent and inaccurate results.

For example, with a `tick_speed` of `30.minutes` and a job that runs every `1.minute` over the course of an hour, the `times_ran` for that job will *not* be 60. It will be 2, assuming minimal passage of time in evaluating the actual clock tick.

#### file

The location of the clock file to test. This defaults to `"./config/clock.rb"` if a value is not provided.

### Assertions Against Test Runs

After running your clock file with `Clockwork::Test.run`, you can use the following methods to assert the clock file ran as expected:

#### ran_job?

`ran_job?` lets you know if a particular job ran during previous executions of `Clockwork::Test.run`.

If the job "test_job" has run, `ran_job?("test_job")` will be true; otherwise, the method will return false.

#### times_run

`times_run` provides the number of times a job has run during previous executions of `Clockwork::Test.run`.

If the job "test_job" never ran, `times_run("test_job")` will be 0; otherwise, it will be the number of times that the event was executed.

#### block_for

`block_for` returns the block that would be handled and run on each execution of a job. This can be useful for ensuring that the block you associated with an event does whatever it is that you expect it to do.

If the job "test_job" never ran, `block_for("test_job")` will return an empty proc; otherwise, the block of code that the event would run is returned, which can then be `call`ed to test.

### RSpec Matchers

`Clockwork::Test` includes a rspec test matcher to check if a job has been run.

To use, add the following to your `spec_helper.rb`:

```ruby
RSpec.configure do |config|
  config.include(Clockwork::Test::RSpec::Matchers)
end
```

The `have_run` matcher checks if a job by the name provided has been run, and allows for a specific number of times to be checked against.

`expect(Clockwork::Test).to have_run("Job Name").exactly(42).times`

You can alternatively pass the number of times in as an optional argument in the `have_run` method, as such:

`expect(Clockwork::Test).to have_run("Job Name", times: 42)`

Chaining `once` to `have_run` will check that the job was run one time only.

If you do not pass the number of times, either with a chained method call or as an optional argument to `have_run`, the matcher will just check if the job was run at all. It provides no assertion as to how often it was run, just that it's at least once.

### Resetting the clock

After each invocation of `Clockwork::Test.run` and assertions made against it, `Clockwork::Test.clear!` should be called. This will wipe all history away and load up the clock file fresh on the next `run`. Failure to do so across tests will carry over past history, which will cause the number of times a job has run to be incorrect and subject to a test ordering bug.

## Contributing

1. Fork it ( https://github.com/kevin-j-m/clockwork-test/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run the tests (`rspec`) and ensure they pass
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
