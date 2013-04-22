# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "redis-socialgraph"
  spec.version       = "0.0.4"
  spec.authors       = ["Adam Derewecki", "Kunal Shah"]
  spec.email         = ["derewecki@gmail.com", "me@kunalashah.com"]
  spec.description   = %q{Implements storage for a basic social graph via Redis}
  spec.summary       = %q{Implements storage for a basic social graph via Redis}
  spec.homepage      = "https://github.com/cameralends/redis-socialgraph"
  spec.license       = "MIT"
  spec.has_rdoc      = false

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = Dir.glob("spec/**/*")

  spec.add_dependency    "redis", "~> 3.0.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "mock_redis"
  spec.add_development_dependency "rspec"
end
