$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "live_studio/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "live_studio"
  s.version     = LiveStudio::VERSION
  s.authors     = ["xinshuaifeng"]
  s.email       = ["xinshuaifeng@126.com"]
  s.summary     = "Summary of LiveStudio."
  s.description = "Description of LiveStudio."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "sqlite3"
end
