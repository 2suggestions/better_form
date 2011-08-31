require 'rails/generators'

class BetterFormGenerator < Rails::Generators::Base
  source_root File.join(File.dirname(__FILE__), "templates")

  desc 'Install the default better_form initializer and partial'
  def generate
    template "better_form.rb", "config/initializers/better_form.rb"
    template "field.html.erb", "app/views/better_form/_field.html.erb"
  end
end
