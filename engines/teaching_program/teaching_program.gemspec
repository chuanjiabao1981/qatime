$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "teaching_program/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "teaching_program"
  s.version     = TeachingProgram::VERSION
  s.authors     = ["wenlonglwl"]
  s.email       = ["lvwenlong1988@sina.com"]
  s.summary     = "Summary of TeachingProgram."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
