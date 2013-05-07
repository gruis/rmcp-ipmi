require File.expand_path("../lib/rmcp/version", __FILE__)

Gem::Specification.new do |s|
  s.name          = "rmcp"
  s.version       = RMCP::VERSION
  s.summary       = 'Remote Management and Control Protocol (RMCP) Ruby implementation'
  s.description   = ''
  s.homepage      = 'http://github.com/simulacre/rmcp'
  s.email         = 'rmcp@simulacre.org'
  s.authors       = ['Caleb Crane']
  s.files         = Dir["lib/**/*.rb", "bin/*", "*.md", "LICENSE.txt"]
  s.require_paths = ["lib"]
  s.executables   = Dir["bin/*"].map{|p| p.split("bin/",2)[1] }

  s.add_dependency "bindata"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "bundler"
end
