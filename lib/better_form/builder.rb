module BetterForm
  class Builder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::UrlHelper

    helpers = field_helpers - %w(label hidden_field fields_for)
    helpers.each do |name|
      define_method(name) do |field_name, *args|
        options = args.extract_options!
        label = options.delete(:label)
        if label == false
          super(field_name, *(args << options))
        elsif label
          generate_label(field_name, label) + super(field_name, *(args << options))
        elsif @template.label_all? == false
          super(field_name, *(args << options))
        else
          generate_label(field_name, label) + super(field_name, *(args << options))
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
      if label == true
        label_text = method.to_s.gsub(/_/, ' ').capitalize
      else
        label_text = label.to_s
      end

      label(method, label_text)
    end
  end
end
