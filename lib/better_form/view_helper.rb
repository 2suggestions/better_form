module BetterForm
  module ViewHelper
    def better_form_for(record_or_name_or_array, *args, &proc)
      options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)

      # Add the class 'better_form' to the list of classes for this form
      options[:html] ||= {}
      options[:html][:class] = "#{options[:html][:class]} better_form"

      # Extract the better_form specific 'label' and 'validate_all' options
      @label_all = options.delete(:label)
      @validate_all = options.delete(:validate)

      # Call the standard Rails form_for with our updated options
      form_for(record_or_name_or_array, *(args << options), &proc)
    end

    def label_all?
      @label_all
    end

    def validate_all?
      @validate_all
    end
  end
end
