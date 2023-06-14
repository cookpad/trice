# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trice/version'

Gem::Specification.new do |spec|
  spec.name          = "trice"
  spec.version       = Trice::VERSION
  spec.authors       = ["moro"]
  spec.email         = ["kyosuke-morohashi@cookpad.com"]

  spec.summary       = %q{Provides reference time concept to application. Use it instead of ad-hoc `Time.now`}
  spec.homepage      = "https://github.com/cookpad/trice"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 6.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "actionpack", ">= 6.1"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rails-controller-testing"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "apparition"
  spec.add_development_dependency "puma"
end
