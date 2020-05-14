# Encoding: UTF-8
Gem::Specification.new do |s|
  s.authors       = ["Brice Sanchez", "Ryan Bigg"]
  s.description   = %q{Refinery CMS's API}
  s.summary       = %q{Refinery CMS's API}
  s.homepage      = 'http://www.refinerycms.com'
  s.license       = 'BSD-3'

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.name          = %q{refinerycms-api}
  s.require_paths = ["lib"]
  s.version       = %q{1.0.0.beta}

  s.add_dependency 'refinerycms-core',  ['~> 4.0', '>= 4.0.0']
  s.add_dependency 'decorators', '~> 2.0'
  s.add_dependency 'rabl', '~> 0.14'
  s.add_dependency 'responders'
end