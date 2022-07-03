# -*- encoding: utf-8 -*-
# stub: replitdb 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "replitdb".freeze
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "changelog_uri" => "https://github.com/janlindblom/ruby-replitdb/blob/main/CHANGELOG.md", "homepage_uri" => "https://github.com/janlindblom/ruby-replitdb", "source_code_uri" => "https://github.com/janlindblom/ruby-replitdb" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jan Lindblom".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-05-04"
  s.email = ["janlindblom@fastmail.fm".freeze]
  s.homepage = "https://github.com/janlindblom/ruby-replitdb".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0".freeze)
  s.rubygems_version = "2.7.6".freeze
  s.summary = "A gem to access Replit Databases.".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<pry>.freeze, ["~> 0.14"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.10"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<rubocop-rake>.freeze, ["~> 0.5"])
      s.add_development_dependency(%q<rubocop-rspec>.freeze, ["~> 2.3"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9"])
    else
      s.add_dependency(%q<pry>.freeze, ["~> 0.14"])
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.10"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 1.7"])
      s.add_dependency(%q<rubocop-rake>.freeze, ["~> 0.5"])
      s.add_dependency(%q<rubocop-rspec>.freeze, ["~> 2.3"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
    end
  else
    s.add_dependency(%q<pry>.freeze, ["~> 0.14"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.10"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rubocop-rake>.freeze, ["~> 0.5"])
    s.add_dependency(%q<rubocop-rspec>.freeze, ["~> 2.3"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
  end
end
