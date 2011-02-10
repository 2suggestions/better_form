module BetterForm
  class Builder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::UrlHelper

    helpers = field_helpers - %w(label hidden_field fields_for)
    helpers.each do |name|
      define_method(name) do |field_name, *args|
        options = args.last.is_a?(Hash) ? args.pop : {}
        label = options.delete(:label)
        if label == false
          super(field_name, *args)
        else
          generate_label(field_name, label) + super(field_name, *args)
        end
      end
    end

    def submit(options = {})
      value = options.delete(:value)
      cancel_url = options.delete(:cancel)
      if cancel_url
        super(value, options) + 'or' + link_to('Cancel', cancel_url)
      else
        super(value, options)
      end
    end

  private
    def generate_label(method, label)
      if label
        label_text = label
      else
        label_text = method.to_s.gsub(/_/, ' ').capitalize
      end

      label(method, label_text)
    end
  end
end
