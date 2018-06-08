# -*- encoding: utf-8 -*-
# stub: commander 4.4.4.pre.alces2 ruby lib

Gem::Specification.new do |s|
  s.name = "commander".freeze
  s.version = "4.4.4.pre.alces2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["TJ Holowaychuk".freeze, "Gabriel Gilder".freeze]
  s.date = "2018-06-08"
  s.description = "The complete solution for Ruby command-line executables. Commander bridges the gap between other terminal related libraries you know and love (OptionParser, HighLine), while providing many new features, and an elegant API.".freeze
  s.email = ["gabriel@gabrielgilder.com".freeze]
  s.executables = ["commander".freeze]
  s.files = [".gitignore".freeze, ".rspec".freeze, ".rubocop.yml".freeze, ".rubocop_todo.yml".freeze, ".travis.yml".freeze, "DEVELOPMENT".freeze, "Gemfile".freeze, "History.rdoc".freeze, "LICENSE".freeze, "Manifest".freeze, "README.md".freeze, "Rakefile".freeze, "bin/commander".freeze, "commander.gemspec".freeze, "lib/commander.rb".freeze, "lib/commander/blank.rb".freeze, "lib/commander/command.rb".freeze, "lib/commander/configure.rb".freeze, "lib/commander/core_ext.rb".freeze, "lib/commander/core_ext/array.rb".freeze, "lib/commander/core_ext/object.rb".freeze, "lib/commander/delegates.rb".freeze, "lib/commander/help_formatters.rb".freeze, "lib/commander/help_formatters/base.rb".freeze, "lib/commander/help_formatters/terminal.rb".freeze, "lib/commander/help_formatters/terminal/command_help.erb".freeze, "lib/commander/help_formatters/terminal/help.erb".freeze, "lib/commander/help_formatters/terminal/subcommand_help.erb".freeze, "lib/commander/help_formatters/terminal_compact.rb".freeze, "lib/commander/help_formatters/terminal_compact/command_help.erb".freeze, "lib/commander/help_formatters/terminal_compact/help.erb".freeze, "lib/commander/help_formatters/terminal_compact/subcommand_help.erb".freeze, "lib/commander/import.rb".freeze, "lib/commander/methods.rb".freeze, "lib/commander/patches/decimal-integer.rb".freeze, "lib/commander/patches/implicit-short-tags.rb".freeze, "lib/commander/patches/validate_inputs.rb".freeze, "lib/commander/platform.rb".freeze, "lib/commander/runner.rb".freeze, "lib/commander/user_interaction.rb".freeze, "lib/commander/version.rb".freeze, "spec/command_spec.rb".freeze, "spec/configure_spec.rb".freeze, "spec/core_ext/array_spec.rb".freeze, "spec/core_ext/object_spec.rb".freeze, "spec/help_formatters/terminal_compact_spec.rb".freeze, "spec/help_formatters/terminal_spec.rb".freeze, "spec/methods_spec.rb".freeze, "spec/patches/validate_inputs_spec.rb".freeze, "spec/runner_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/ui_spec.rb".freeze]
  s.homepage = "https://github.com/commander-rb/commander".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "The complete solution for Ruby command-line executables".freeze
  s.test_files = ["spec/command_spec.rb".freeze, "spec/configure_spec.rb".freeze, "spec/core_ext/array_spec.rb".freeze, "spec/core_ext/object_spec.rb".freeze, "spec/help_formatters/terminal_compact_spec.rb".freeze, "spec/help_formatters/terminal_spec.rb".freeze, "spec/methods_spec.rb".freeze, "spec/patches/validate_inputs_spec.rb".freeze, "spec/runner_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/ui_spec.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>.freeze, ["~> 1.7.2"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.49.1"])
    else
      s.add_dependency(%q<highline>.freeze, ["~> 1.7.2"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.49.1"])
    end
  else
    s.add_dependency(%q<highline>.freeze, ["~> 1.7.2"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.49.1"])
  end
end
