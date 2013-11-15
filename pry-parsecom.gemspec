# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pry-parsecom/version'

Gem::Specification.new do |gem|
  gem.name          = "pry-parsecom"
  gem.version       = Parsecom::VERSION
  gem.authors       = ["Ando Yasushi"]
  gem.email         = ["andyjpn@gmail.com"]
  gem.description   = %q{CLI for parse.com}
  gem.summary       = %q{CLI for parse.com}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "pry"
  gem.add_dependency "parsecom"
  gem.add_dependency "mechanize"
end
