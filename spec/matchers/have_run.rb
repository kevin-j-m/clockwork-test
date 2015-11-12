RSpec::Matchers.define :have_run do |job_name|
  match do |clock_test|
    @times_run ||= 1
    clock_test.manager.times_run(job_name) == @times_run
  end

  match_when_negated do |clock_test|
    !clock_test.manager.ran_job?(job_name)
  end

  chain :exactly do |count|
    @times_run = count
  end

  chain :times do
    # sugar so sweet
  end

  chain :time do
    # sugar so sweet
  end

  failure_message { "expected Clockwork::Test to have run \"#{job_name}\" #{@times_run} #{@times_run == 1 ? 'time' : 'times'}." }
  failure_message_when_negated { "expected Clockwork::Test to not have run \"#{job_name}\"." }
end
