$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "qawechat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "qawechat"
  s.version     = Qawechat::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.summary     = "wechat engine."
  s.description = "wechat for qatime."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0.3"
  s.add_dependency "wechat", "~> 0.7.20"
  s.add_dependency "omniauth-wechat-oauth2", "~> 0.1.0"

  s.add_development_dependency "sqlite3"
end
