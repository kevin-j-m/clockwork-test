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
