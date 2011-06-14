module BetterForm
  module ViewHelper
    def better_form_for(record_or_name_or_array, *args, &proc)
      options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
      options[:html] ||= {}

      # Call apply_form_for_options! here to have Rails set the class, id and method for the form as usual
      # We need to call this here (rather than implicitly through the later form_for call) because
      # apply_form_for_options! uses reverse_merge!, so out better_form class would override the new_whatever or
      # edit_whatever class applied by Rails
      apply_form_for_options!(record_or_name_or_array, options)

      # Add the class 'better_form' to the list of classes for this form
      options[:html][:class] = "#{options[:html][:class]} better_form"

      # Extract the better_form specific 'label' and 'validate_all' options
      @label_all = options.delete(:label)
      @validate_all = options.delete(:validate)

      # Call the standard Rails form_for with our updated options
      form_for(record_or_name_or_array, *(args << options), &proc)
    end

    def better_fields_for(record_or_name_or_array, *args, &proc)
      options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)

      # Extract the better_form specific 'label' and 'validate_all' options
      @label_all = options.delete(:label)
      @validate_all = options.delete(:validate)

      # Call the standard Rails fields_for with our updated options
      fields_for(record_or_name_or_array, *(args << options), &proc)
    end

    def label_all?
      @label_all
    end

    def validate_all?
      @validate_all
    end
  end
end
