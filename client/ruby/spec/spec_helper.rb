require "rspec"
require "social_coffee"

Dir[File.join(File.dirname(__FILE__), "/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
    config.order = "random"
end