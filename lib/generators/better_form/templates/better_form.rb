module BetterForm
  class Builder
    def better_form_field(form_field, field_type, generated_label, error_messages, options)
      if [:radio_button, :check_box].include?(field_type.to_sym)
        content = @template.render(:partial => 'better_form/inline_field', :locals => { :form_field => form_field, :field_type => field_type, :generated_label => generated_label, :error_messages => error_messages, :options => options })
      else
        content = @template.render(:partial => 'better_form/field', :locals => { :form_field => form_field, :field_type => field_type, :generated_label => generated_label, :error_messages => error_messages, :options => options })
      end
      content
    end
  end
end
