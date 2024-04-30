Gem::Specification.new do |s|
  s.name = "cv4_sdk"
  s.version = "1.0.0"
  s.summary = "Gem for CV4 API"
  s.description = "Gem for CV4 API"
  s.authors = ["Berlimioz"]
  s.homepage = "https://github.com/mipise/cv4_sdk"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "activesupport", ">= 6.1.5"

  s.add_development_dependency "cutest", "~> 1.2"
  s.add_development_dependency "dotenv", "~> 2.7"
end
