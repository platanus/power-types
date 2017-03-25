# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'power_types/version'

Gem::Specification.new do |spec|
  spec.name          = "power-types"
  spec.version       = PowerTypes::VERSION
  spec.authors       = ["Ignacio Baixas", "Felipe Balart"]
  spec.email         = ["ignacio@platan.us", "felipe@platan.us"]

  spec.summary       = "Power Types for Rails by Platanus"
  spec.description   = "Power Types for Rails by Platanus"
  spec.homepage      = "https://github.com/platanus/power-types"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rspec-nc", "~> 0.2"
  spec.add_development_dependency "guard", "~> 2.11"
  spec.add_development_dependency "guard-rspec", "~> 4.5"
  spec.add_development_dependency "terminal-notifier-guard", "~> 1.6", ">= 1.6.1"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-remote", "~> 0.1"
  spec.add_development_dependency "pry-byebug", "~> 3.2"
  spec.add_development_dependency "pry-nav", "~> 0.2"
  spec.add_development_dependency "coveralls"
end
