require_relative 'lib/ttoken/version'

Gem::Specification.new do |spec|
  spec.name          = "ttoken"
  spec.version       = Ttoken::VERSION
  spec.authors       = ["Suraj Patil"]
  spec.email         = ["patilsuraj767@gmail.com"]

  spec.summary       = %q{ttoken is a command line utility to generate time based token/otp.}
  spec.homepage      = "https://github.com/patilsuraj767/ttoken"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|images)/}) }
  end

  spec.executables = ['ttoken']
  spec.require_paths = ["lib"]

  spec.add_dependency 'rotp', '5.1.0'

end
