module BetterForm
  class Builder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::UrlHelper

    helpers = field_helpers + %w(date_select datetime_select time_select collection_select select time_zone_select) - %w(label hidden_field fields_for)
    helpers.each do |field_type|
      define_method(field_type) do |field_name, *args|
        options = args.extract_options!
        validations = generate_validations(@object, field_name)
        options.merge!(validations)
        label = options.delete(:label)
        if label == false
          super(field_name, *(args << options))
        elsif label
          generate_label(field_type, field_name, label) + super(field_name, *(args << options))
        elsif @template.label_all? == false
          super(field_name, *(args << options))
        else
          generate_label(field_type, field_name, label) + super(field_name, *(args << options))
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
    def generate_label(field_type, method, label)
      if label == true
        label_text = method.to_s.gsub(/_/, ' ').capitalize
      else
        label_text = label.to_s
      end

      options = { :class => :inline } if %w(check_box radio_button).include?(field_type)
      label(method, label_text, options ||= {})
    end

    def generate_validations(object, attribute)
      validations = {}
      @attribute = attribute

      # Don't try to add validations for an object that doesn't have _validators
      return {} unless object.respond_to?(:_validators)

      # Iterate over each validator for this attribute, and add the appropriate HTML5 data-* attributes
      object._validators[attribute].each do |validator|
        @options = validator.options
        validation = case validator
          when ActiveModel::Validations::AcceptanceValidator
            if validation_applies?
              { 'data-validates-acceptance' => validation_message('must be accepted') }
            end
          when ActiveModel::Validations::ConfirmationValidator
            if validation_applies?
              {}
            end
          when ActiveModel::Validations::ExclusionValidator
            {}
          when ActiveModel::Validations::FormatValidator
            if validation_applies?
              { 'data-validates-format' => validation_message, 'data-validates-format-with' => validator.options[:with].inspect }
            end
          when ActiveModel::Validations::InclusionValidator
            {}
          when ActiveModel::Validations::LengthValidator
            if validation_applies?
              {}
            end
          when ActiveModel::Validations::NumericalityValidator
            if validation_applies?
              { 'data-validates-numericality' => validation_message('is not a number') }
            end
          when ActiveModel::Validations::PresenceValidator
            { 'data-validates-presence' => validation_message('is required') }
        end
        validations.merge!(validation ||= {})
      end

      validations
    end

    def validation_applies?
      case @options[:on]
        when :create then true if @object.new_record?
        when :update then true if !@object.new_record?
        else true
      end
    end

    def validation_message(suffix = 'is invalid')
      @options[:message] ? @options[:message] : "#{@attribute.to_s.humanize} #{suffix}"
    end
  end
end
