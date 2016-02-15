# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'imgdiff/version'

Gem::Specification.new do |spec|
  spec.name          = "imgdiff"
  spec.version       = Imgdiff::VERSION
  spec.authors       = ["bonbon0605"]
  spec.email         = ["ogasawara_2005@yahoo.co.jp"]

  spec.summary       = %q{add command to confirm diff between image files}
  spec.homepage      = "https://github.com/bonbon0605/imgdiff"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "rmagick", "~> 2.15.4"
  spec.add_dependency "thor", "~> 0.19.1"
end
