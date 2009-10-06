$:.unshift('lib')
# Add your own tasks in files placed in lib/tasks ending in .rake, for example
# lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

require 'tasks/rails'
require 'fileutils'

spec = Gem::Specification.new do |s|
  s.name = 'wizardly'
  s.version = '0.1.8.9'
  s.platform = Gem::Platform::RUBY
  s.description = 'Create wizards from any model in three steps'
  s.summary = 'Produces controllers and wizard scaffolding for models with validation_groups'

  #move all files in lib/generators -> rails_generators
  FileUtils.rm_rf "rails_generators"
  FileUtils.mkdir "rails_generators"
  FileUtils.cp_r "lib/generators/.", "rails_generators"
  exclude_files = FileList['**/*.log'] + FileList['lib/generators/**/*'] + FileList['lib/tasks/**/*']
  s.files = FileList['{lib,rails_generators}/**/*'] + %w(CHANGELOG.rdoc init.rb LICENSE README.rdoc) - exclude_files
  s.require_path = 'lib'
  s.has_rdoc = true
  #s.test_files = Dir['spec/*_spec.rb']

  s.author = 'Jeff Patmon'
  s.email = 'jpatmon@yahoo.com'
  s.homepage = 'http://github.com/jeffp/wizardly/tree/master'
end

require 'spec/version'
require 'spec/rake/spectask'

namespace :spec do
  desc "Run all specs"
  task :all=>[:macro, :gen, :scaffold, :callback, :callback2, :callback3, :persist, :sandbox, :session]
  desc "Test the AvatarController"
  Spec::Rake::SpecTask.new(:avatar) do |t|
    t.spec_files = FileList['spec/integrations/avatar_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']
    t.rcov = false
  end
  desc "Test the MacroController"
  Spec::Rake::SpecTask.new(:macro) do |t|
    t.spec_files = FileList['spec/integrations/macro_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the DataModes2Controller"
  Spec::Rake::SpecTask.new(:persist2) do |t|
    t.spec_files = FileList['spec/integrations/data_modes2_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the DataModesController"
  Spec::Rake::SpecTask.new(:persist) do |t|
    t.spec_files = FileList['spec/integrations/data_modes_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the SandboxController"
  Spec::Rake::SpecTask.new(:sandbox) do |t|
    t.spec_files = FileList['spec/integrations/sandbox_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the SessionController"
  Spec::Rake::SpecTask.new(:session) do |t|
    t.spec_files = FileList['spec/integrations/session_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the GeneratedController"
  Spec::Rake::SpecTask.new(:gen=>[:generate_controller]) do |t|
    t.spec_files = FileList['spec/integrations/generated_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Generate GeneratedController for spec test"
  task :generate_controller=>[:environment] do
    require 'rails_generator'
    require 'rails_generator/scripts/generate'    
    gen_argv = []
    gen_argv << "wizardly_controller" << "generated" << "user" << "/main/finished" << "/main/canceled" << "--force"
    Rails::Generator::Scripts::Generate.new.run(gen_argv)
  end
  desc "Test the ScaffoldTestController"
  Spec::Rake::SpecTask.new(:scaffold) do |t|
    t.spec_files = FileList['spec/integrations/scaffold_test_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the CallbacksController"
  Spec::Rake::SpecTask.new(:callback) do |t|
    t.spec_files = FileList['spec/controllers/callbacks_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the Callbacks2Controller"
  Spec::Rake::SpecTask.new(:callback2) do |t|
    t.spec_files = FileList['spec/controllers/callbacks2_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']    
    t.rcov = false
  end
  desc "Test the Callbacks3Controller"
  Spec::Rake::SpecTask.new(:callback3) do |t|
    t.spec_files = FileList['spec/controllers/callbacks3_spec.rb']
    t.libs << 'lib' << 'spec' << 'spec/integrations'
    t.spec_opts = ['--options', 'spec/spec.opts']
    t.rcov = false
  end
end


desc "Generate documentation for the #{spec.name} plugin."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = spec.name
  # #rdoc.template = '../rdoc_template.rb'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGELOG.rdoc', 'LICENSE', 'lib/wizardly.rb', 'lib/wizardly/**/*.rb')
end

desc 'Generate a gemspec file.'
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end

Rake::GemPackageTask.new(spec) do |p|
  FileUtils.rm_rf "rails_generators"
  FileUtils.mkdir "rails_generators"
  FileUtils.cp_r "lib/generators/.", "rails_generators"
  p.gem_spec = spec
  p.need_tar = RUBY_PLATFORM =~ /mswin/ ? false : true
  p.need_zip = true
end

Dir['tasks/**/*.rake'].each {|rake| load rake}
