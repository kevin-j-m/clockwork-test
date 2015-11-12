RSpec::Matchers.define :log do |job_output|
  match do |clock_test|
    clock_test.manager.block_for(@job_name).call == job_output
  end

  chain :for do |job_name|
    @job_name = job_name
  end

  failure_message { "expected Clockwork::Test to have logged \"#{job_output}\" by running #{job_name}." }
end
