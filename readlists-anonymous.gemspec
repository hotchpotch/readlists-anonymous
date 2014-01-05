# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'readlists/anonymous/version'

Gem::Specification.new do |spec|
  spec.name          = "readlists-anonymous"
  spec.version       = Readlists::Anonymous::VERSION
  spec.authors       = ["Yuichi Tateno"]
  spec.email         = ["hotchpotch@gmail.com"]
  spec.summary       = %q{Readlists API for anonymous lists.}
  spec.description   = %q{Readlists API for anonymous lists.}
  spec.homepage      = "https://github.com/hotchpotch/readlists-anonymous"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
