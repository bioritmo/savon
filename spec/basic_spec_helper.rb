require "rake"
require "spec"
require "mocha"
require "fakeweb"

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

require "bioritmo/savon"
BioRitmo::Savon::Request.log = false
