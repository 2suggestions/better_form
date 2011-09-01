module BetterForm
  class Builder
    def better_form_field(form_field, field_type, generated_label, error_messages, options)
      content = @template.render(:partial => 'better_form/field', :locals => { :form_field => form_field, :field_type => field_type, :generated_label => generated_label, :error_messages => error_messages, :options => options })
      content
    end
  end
end
