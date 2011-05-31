module BetterForm
  class Builder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::UrlHelper

    helpers = field_helpers + %w(date_select datetime_select time_select collection_select select time_zone_select) - %w(label hidden_field fields_for)
    helpers.each do |field_type|
      define_method(field_type) do |field_name, *args|
        options = args.extract_options!

        # Extract the prefix and suffix (if any), and make them html_safe
        prefix = (options.delete(:prefix) || '').html_safe
        suffix = (options.delete(:suffix) || '').html_safe
        description = (options.delete(:description) || '').html_safe

        # Extract the label argument and validate argument
        label = options.delete(:label)
        validate = options.delete(:validate)

        error_message = ''.html_safe

        # If this field is explicitly validated, or this field and the whole form aren't explicitly *not* validated
        if validate or (validate != false and @template.validate_all? != false)
          # Generate validations for the field
          validations = generate_validations(@object, field_name)
          options.merge!(validations)

          # Add an 'invalid' class to it if it has errors
          unless @object.errors[field_name].blank?
            css_classes = options.delete(:class)
            options.merge!({ :class => "#{css_classes} invalid" })
            error_message = generate_error(field_name)
          end
        end

        # Generate a label if necessary
        if (label == false) or (label == nil and @template.label_all? == false)
          label = ''.html_safe
        else
          label = generate_label(field_type, field_name, label)
        end

        # Generate the field itself
        field = super(field_name, *(args << options))

        # Generate the field description
        description = generate_description(description)

        # Join all the parts together to make a better form field!
        return label + content_tag(:span, prefix + field + suffix + description) + error_message
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

    def generate_description(description)
      content_tag(:span, description, :class => 'field-desc') unless description.blank?
    end

    def generate_error(field_name)
      content_tag(:span, @object.errors[field_name].join(tag(:br)).html_safe, :class => :error_message)
    end

    def generate_validations(object, attribute)
      validations = {}
      @attribute = attribute

      # Don't try to add validations for an object that doesn't have _validators
      return {} unless object.respond_to?(:_validators)

      # Iterate over each validator for this attribute, and add the appropriate HTML5 data-* attributes
      object._validators[attribute].each do |validator|
        @validation_options = validator.options
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
      case @validation_options[:on]
        when :create then true if @object.new_record?
        when :update then true if !@object.new_record?
        else true
      end
    end

    def validation_message(suffix = 'is invalid')
      @validation_options[:message] ? @validation_options[:message] : "#{@attribute.to_s.humanize} #{suffix}"
    end
  end
end
