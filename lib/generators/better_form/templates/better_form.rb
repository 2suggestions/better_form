module BetterForm
  class Builder
    def better_form_field(form_field, error_messages, options)
      content = @template.render(:partial => 'better_form/field', :locals => { :field => form_field, :error_messages => error_messages, :options => options })
      content
    end
  end
end
