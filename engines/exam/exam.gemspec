$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "exam/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "exam"
  s.version     = Exam::VERSION
  s.authors     = ["xinshuaifeng"]
  s.email       = ["xinshuaifeng@126.com"]
  s.homepage    = "https://qatime.cn"
  s.summary     = "考试系统."
  s.description = "英语语音听力考试."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "sqlite3"
end
