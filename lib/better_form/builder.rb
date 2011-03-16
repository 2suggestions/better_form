module BetterForm
  class Builder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::UrlHelper

    helpers = field_helpers + %w(date_select datetime_select time_select collection_select select time_zone_select) - %w(label hidden_field fields_for)
    helpers.each do |name|
      define_method(name) do |field_name, *args|
        options = args.extract_options!
        validations = generate_validations(@object, field_name)
        options.merge!(validations)
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
        super(value, options) + "<span class='cancel'>or #{link_to('Cancel', cancel_url)}</span>".html_safe
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

    def generate_validations(object, attribute)
      validations = {}
      # Iterate over each validator for this attribute, and add the appropriate HTML5 data-* attributes
      object._validators[attribute].each do |validator|
        validation = case validator
          when ActiveModel::Validations::AcceptanceValidator
            { 'data-validations-acceptance' => true }
          when ActiveModel::Validations::ConfirmationValidator
            {}
          when ActiveModel::Validations::ExclusionValidator
            {}
          when ActiveModel::Validations::FormatValidator
            { 'data-validations-format' => true, 'data-validations-format-with' => validator.options[:with] }
          when ActiveModel::Validations::InclusionValidator
            {}
          when ActiveModel::Validations::LengthValidator
            {}
          when ActiveModel::Validations::NumericalityValidator
            { 'data-validations-numericality' => true }
          when ActiveModel::Validations::PresenceValidator
            { 'data-validations-presence' => true }
          else
            {}
        end
        validations.merge!(validation)
      end

      validations
    end
  end
end
