require "bundler"
Bundler.setup

require "rspec/core/rake_task"
Rspec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("better_form.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["better_form.gemspec"] do
  system "gem build better_form.gemspec"
  system "gem install better_form-#{BetterForm::VERSION}.gem"
end
