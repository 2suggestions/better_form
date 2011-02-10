require "better_form/view_helper"
require "better_form/builder"

ActiveSupport.on_load(:action_view) do
  include BetterForm::ViewHelper
end
