$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "resource/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "resource"
  s.version     = Resource::VERSION
  s.authors     = ["xinshuaifeng"]
  s.email       = ["xinshuaifeng@126.com"]
  # s.homepage    = "TODO"
  s.summary     = "Qatime Resource Center"
  # s.description = "TODO: Description of Resource."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"
  s.add_dependency "carrierwave"
  s.add_dependency "mini_magick"
  s.add_dependency "carrierwave-aliyun"

  s.add_development_dependency "sqlite3"
end
