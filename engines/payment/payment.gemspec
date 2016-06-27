$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "payment/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "payment"
  s.version     = Payment::VERSION
  s.authors     = ["xinshuaifeng"]
  s.email       = ["xinshuaifeng@126.com"]
  s.summary     = "Summary of Payment."
  s.description = "Description of Payment."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"
  s.add_dependency "rqrcode"

  s.add_development_dependency "wx_pay"

  s.add_development_dependency "sqlite3"
end
