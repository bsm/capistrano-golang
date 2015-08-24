# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-golang"
  gem.version       = '0.2.1'
  gem.authors       = ["Dimitrij Denissenko"]
  gem.email         = ["dimitrij@blacksquaremedia.com"]
  gem.description   = %q{Go deployment tasks for Capistrano}
  gem.summary       = %q{Capistrano with Go(lang)}
  gem.homepage      = "https://github.com/bsm/capistrano-golang"
  gem.licenses      = ["MIT"]

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '~> 3.0'
end
