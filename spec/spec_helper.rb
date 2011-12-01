require 'bundler/setup'
require 'rspec'

$:.unshift Bundler.root.join("CookieInspector").to_s

require 'CIController'

# Pull in the support files
Dir[ Bundler.root.join("spec/support/**/*.rb").to_s ].each{|f| require f}
