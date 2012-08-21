# -*- encoding: utf-8 -*-
require File.expand_path('../lib/command_status_apparatus/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gary Gordon"]
  gem.email         = ["gfgordon@gmail.com"]
  gem.description   = %q{Log runtimes for rails tasks}
  gem.summary       = %q{Log runtimes for rails tasks}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test)/})
  gem.name          = "command_status_apparatus"
  gem.require_paths = ["lib"]
  gem.version       = CommandStatusApparatus::VERSION

  gem.add_runtime_dependency 'rails', '~> 3.0'

  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency('minitest')
  gem.add_development_dependency('turn')
  gem.add_development_dependency('simplecov')
end
