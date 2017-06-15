$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "chat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "chat"
  s.version     = Chat::VERSION
  s.authors     = ["xinshuaifeng"]
  s.email       = ["xinshuaifeng@126.com"]
  s.homepage    = ""
  s.summary     = "Summary of Chat."
  s.description = "Description of Chat."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0.3"

  s.add_development_dependency "sqlite3"
end
