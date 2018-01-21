# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "logbook"

Gem::Specification.new do |spec|
  spec.name          = "logbook"
  spec.version       = Logbook::VERSION
  spec.authors       = ["Gabriel Malkas"]
  spec.email         = ["gabriel.malkas@gmail.com"]

  spec.summary       = "Ruby library for the Logbook file format"
  spec.description   = "Ruby library for the Logbook file format"
  spec.homepage      = "https://www.logbook.sh"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_runtime_dependency "parslet", "~> 1.8"
end
