require_relative "lib/time_tracking/version"

Gem::Specification.new do |spec|
  spec.name = "time_tracking"
  spec.version = TimeTracking::VERSION
  spec.summary = "Time tracking for Runwell, as a plugin"
  spec.authors = [ "Runwell" ]
  spec.homepage = "https://github.com/Martin-Business-Consultants/runwell-time-tracking"
  spec.license = "FSL-1.1-MIT"
  spec.files = Dir["{app,config,db,lib}/**/*"]
  spec.required_ruby_version = ">= 3.3"
  spec.add_dependency "rails", ">= 8.1"
end
