# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redirect_backoffice/version'

Gem::Specification.new do |gem|
  gem.name          = "redirect_backoffice"
  gem.version       = RedirectBackoffice::VERSION
  gem.authors       = ["Christoph Trautwein"]
  gem.email         = ["trautwein@scientist.com"]
  gem.description   = %q{Backoffice for redirect_engine gem}
  gem.summary       = %q{Web-UI for editing redirects}
  gem.homepage      = "http://chtw.de/redirect"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "sinatra"
end
