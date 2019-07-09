# Load the Rails application.
require_relative 'application'

Rails.application.configure do
  config.time_zone = 'New Delhi'
  config.active_record.default_timezone = :local
end

# Initialize the Rails application.
Rails.application.initialize!
