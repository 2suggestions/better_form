module BetterForm
  class Builder
    def better_form_field(field)
      content = @template.render(:partial => 'better_form/field', :locals => { :field => field })
      content
    end
  end
end
