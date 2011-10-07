require 'rails/generators'

class BetterFormGenerator < Rails::Generators::Base
  source_root File.join(File.dirname(__FILE__), "templates")

  desc 'Install the default better_form initializer and partial'
  def generate
    copy_file "better_form.rb", "config/initializers/better_form.rb"
    copy_file "field.html.erb", "app/views/better_form/_field.html.erb"
    copy_file "inline_field.html.erb", "app/views/better_form/_inline_field.html.erb"
  end
end
