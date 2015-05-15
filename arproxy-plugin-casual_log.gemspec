# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "arproxy-plugin-casual_log"
  spec.version       = "0.0.1"
  spec.authors       = ["Genki Sugawara"]
  spec.email         = ["sugawara@cookpad.com"]
  spec.summary       = %q{Plug-in that colorize the bad query for Arproxy.}
  spec.description   = %q{Plug-in that colorize the bad query for Arproxy.}
  spec.homepage      = "https://github.com/winebarrel/arproxy-plugin-casual_log"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "arproxy", "~> 0.2.0"
  spec.add_dependency "mysql2"
  spec.add_dependency "term-ansicolor"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
