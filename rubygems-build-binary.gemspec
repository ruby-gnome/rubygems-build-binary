require_relative "lib/rubygems-build-binary/version"

Gem::Specification.new do |spec|
  spec.name = "rubygems-build-binary"
  spec.version = RubyGemsBuildBinary::VERSION
  spec.authors = ["Sutou Kouhei"]
  spec.email = ["kou@clear-code.com"]
  spec.summary = "RubyGems plugin that adds `gem build_binary` sub command"
  spec.description = <<-DESCRIPTION.strip
`gem build_binary` builds a binary gem for the current Ruby and platform
from a source (`platform == ruby`) gem.
  DESCRIPTION
  spec.homepage = "https://github.com/ruby-gnome/rubygems-build-binary"
  spec.licenses = ["MIT"]
  spec.require_paths = ["lib"]

  spec.files = ["LICENSE", "README.md", "Rakefile"]
  spec.files += Dir.glob("lib/**/*.rb")
end
