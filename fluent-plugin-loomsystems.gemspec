# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-loomsystems"
  spec.version       = "0.0.1"
  spec.authors       = ["doron yehuda at loomsystems dev team"]
  spec.email         = ["doron.yehuda@loomsystems.com"]
  spec.summary       = "loomsystems output plugin for Fluentd - enabling the transfer of fluentd events trough a secured ssl tcp connection"
  spec.homepage      = "https://www.loomsystems.com"
  spec.license       = "MIT"

  spec.files         = [".gitignore", "Gemfile", "LICENSE", "README.md", "Rakefile", "fluent-plugin-loomsystems.gemspec", "lib/fluent/plugin/out_loomsystems.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yajl-ruby", "~> 1.2"
end
