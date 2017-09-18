require_relative 'lib/hots_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'hots_api'
  spec.version       = HotsApi::VERSION
  spec.authors       = ['Tobias Bühlmann']
  spec.email         = ['tobias@xn--bhlmann-n2a.de']

  spec.summary       = 'Client library for the hotsapi.net API'
  spec.description   = 'hots_api is a client library for the Heroes of the Storm replay metadata API hotsapi.net.'
  spec.homepage      = 'https://github.com/tbuehlmann/hots_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'virtus'
  spec.add_dependency 'http'
end
