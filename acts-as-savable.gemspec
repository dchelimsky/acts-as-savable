# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts-as-savable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Chelimsky"]
  gem.email         = ["dchelimsky@gmail.com"]
  gem.description   = %q{ActiveRecord plugin for a view-backed model. Stores data to an underlying table.}
  gem.summary       = %q{ActiveRecord plugin for a view-backed model.}
  gem.homepage      = "http://github.com/dchelimsky/acts-as-savable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts-as-savable"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsSavable::VERSION
end
