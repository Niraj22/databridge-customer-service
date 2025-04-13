# frozen_string_literal: true

require_relative "lib/databridge_shared/version"

Gem::Specification.new do |spec|
  spec.name = "databridge_shared"
  spec.version = DataBridgeShared::VERSION
  spec.authors = ["Niraj Budhathoki"]
  spec.email = ["nirajbudhathoki3@gmail.com"]

  spec.summary = "DataBridge shared libraries for microservices communication"
  spec.description = "Common utilities, event schemas, and client libraries for the DataBridge system"
  spec.homepage = "https://github.com/Niraj22/databridge-shared"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Niraj22/databridge-shared"
  spec.metadata["changelog_uri"] = "https://github.com/Niraj22/databridge-shared/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob("{lib,app}/**/*") + %w[README.md LICENSE.txt]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  # Add these to the gemspec dependencies
  spec.add_dependency "avro_turf", "~> 1.18"
  spec.add_dependency "bunny", "~> 2.24"
  spec.add_dependency "jwt", "~> 2.10.1"
  spec.add_dependency "ruby-kafka", "~> 1.5"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rubocop", "~> 1.75", ">= 1.75.1"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
end
