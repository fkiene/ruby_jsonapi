lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jsonapi/serializer/version'

Gem::Specification.new do |gem|
  gem.name = 'ruby_jsonapi'
  gem.version = JSONAPI::Serializer::VERSION
  gem.authors = ['JSON:API Serializer Community']
  gem.email = ''

  gem.summary = 'Fast, enhanced, and compliant Ruby implementation of the JSON:API specification'
  gem.description = 'Fast, enhanced, and compliant Ruby implementation of the JSON:API specification, evolving from jsonapi-serializer/jsonapi-serializer (originally Netflix/fast_jsonapi) with enhanced features beyond serialization.'
  gem.homepage = 'https://github.com/fkiene/ruby_jsonapi'
  gem.licenses = ['Apache-2.0']

  gem.files = Dir['lib/**/*']
  gem.require_paths = ['lib']
  gem.extra_rdoc_files = ['LICENSE.txt', 'README.md']

  gem.add_runtime_dependency('activesupport', '>= 4.2')

  gem.metadata = {
    'homepage_uri' => gem.homepage,
    'bug_tracker_uri' => 'https://github.com/fkiene/ruby_jsonapi/issues',
    'documentation_uri' => 'https://fkiene.github.io/ruby_jsonapi/',
    'changelog_uri' => 'https://github.com/fkiene/ruby_jsonapi/blob/main/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/fkiene/ruby_jsonapi',
    'rubygems_mfa_required' => 'true',
    'github_repo' => 'https://github.com/fkiene/ruby_jsonapi'
  }

  gem.add_development_dependency('activerecord')
  gem.add_development_dependency('bundler')
  gem.add_development_dependency('byebug')
  gem.add_development_dependency('ffaker')
  gem.add_development_dependency('jsonapi-rspec', '>= 0.0.5')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rubocop')
  gem.add_development_dependency('rubocop-performance')
  gem.add_development_dependency('rubocop-rspec')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('sqlite3')
end
