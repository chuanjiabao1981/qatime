$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "course_library/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "course_library"
  s.version     = CourseLibrary::VERSION
  s.authors     = ["wenlonglwl"]
  s.email       = ["lvwenlong1988@sina.com"]
  s.summary     = "Summary of CourseLibrary."
  s.description = "Description of CourseLibrary."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
