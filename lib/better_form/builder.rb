module BetterForm
  # Raised when the better_form initializer has not been installed
  class InstallationError < StandardError
  end

  class Builder < ActionView::Helpers::FormBuilder
    helpers = field_helpers + %w(date_select datetime_select time_select collection_select select time_zone_select) - %w(label hidden_field fields_for)
    helpers.each do |field_type|
      define_method(field_type) do |field_name, *args|
        options = args.extract_options!

        error_messages = @object.errors[field_name]

        # If this field is explicitly validated, or this field and the whole form aren't explicitly *not* validated
        validate = options.delete(:validate)
        if validate or (validate != false and @template.validate_all? != false)
          # Generate validations for the field
          validations = generate_validations(@object, field_name)
          options.merge!(validations)
        end

        # Generate label_text if necessary, or set it to nil if we're not labelling this field
        label = options.delete(:label)
        if (options[:label] == false) or (options[:label] == nil and @template.label_all? == false)
          options[:label_text] = nil
        else
          options[:label_text] ||= field_name.to_s.humanize
        end

        # Generate the field itself
        field = super(field_name, *(args << options))

        # Join all the parts together to make a better form field!
        better_form_field(field, error_messages, options)
      end
    end

    def better_form_field(field, error_messages, options)
      raise BetterForm::InstallationError, "You need to run `rails generate better_form` before you can use better_form"
    end

  private
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
