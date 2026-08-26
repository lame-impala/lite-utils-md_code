# frozen_string_literal: true

require_relative 'lib/lite/utils/md_code'

Gem::Specification.new do |spec|
  spec.name = 'lite-utils-md_code'
  spec.version = Lite::Utils::MdCode::VERSION
  spec.authors = ['Tomas Milsimer']
  spec.email = ['tomas.milsimer@protonmail.com']

  spec.summary = 'Connects a MD file to your code through MD fencing'
  spec.description = <<~DESC
     TODO
  DESC

  spec.required_ruby_version = '>= 3.0.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ['lib']
  spec.licenses = ['MIT']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
