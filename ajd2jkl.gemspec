# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ajd2jkl/version'

Gem::Specification.new do |spec|
    spec.name          = 'ajd2jkl'
    spec.version       = Ajd2jkl::VERSION
    spec.authors       = ['Florent Ruard-Dumaine']
    spec.email         = ['florent@daysofwonder.com']

    spec.summary       = %q{'Command to parse code files with apidocjs comments to generate API documentation in Jekyll format}
    spec.description   = %q{...}
    spec.homepage      = 'TODO: Put your gem\'s website or public repo URL here.'
    spec.license       = 'MIT'

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
    # to allow pushing to a single host or delete this section to allow pushing to any host.
    if spec.respond_to?(:metadata)
        spec.metadata['allowed_push_host'] = 'TODO: Set to \'http://mygemserver.com\''
    else
        raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
    end

    spec.files = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
    end
    spec.bindir        = 'bin'
    spec.executables   = ['ajd2jkl']
    spec.require_paths = ['lib']

    spec.add_development_dependency 'bundler', '~> 1.14'
    spec.add_development_dependency 'rake', '~> 10.0'
    spec.add_development_dependency 'minitest', '~> 5.0'

    spec.add_dependency 'commander'
    spec.add_dependency 'jekyll', '~> 3.6.0'
    spec.add_dependency 'rouge'
    spec.add_dependency 'jekyll-watch'
    spec.add_dependency 'jekyll-theme-hydejack', '~> 6.0'
end
