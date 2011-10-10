require 'rails/generators'

class BetterFormGenerator < Rails::Generators::Base
  source_root File.join(File.dirname(__FILE__), "templates")

  desc 'Install the default better_form initializer and partial'
  def generate
    copy_file "initializer.rb", "config/initializers/better_form.rb"
    copy_file "field_partial.html.erb", "app/views/better_form/_field.html.erb"
    copy_file "inline_field_partial.html.erb", "app/views/better_form/_inline_field.html.erb"
    copy_file "javascript_validation.js.coffee", "vendor/assets/javascripts/better_form.js.coffee"
  end
end
