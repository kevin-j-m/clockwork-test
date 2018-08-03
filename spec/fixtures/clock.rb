require "clockwork"

module Clockwork
  CONSTANT = "redefined on subsequent loads".freeze

  configure do |config|
    config[:tz] = "US/Eastern"
  end

  handler { |job| logger.info "Running #{job}" }

  every(1.minute, "Run a job") do
    "Here's a running job"
  end

  every(1.day, "Run at certain time", at: "17:30") do
    "Run at certain time"
  end

  every(1.day, "Run but not at start", skip_first_run: true) do
    "Run at certain time"
  end

  every(1.hour, "Run at 10 past the hour", at: "**:10") do
    "Run at 10 past the hour"
  end
end
