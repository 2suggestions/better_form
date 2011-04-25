module BetterForm
  module ViewHelper
    def better_form_for(record_or_name_or_array, *args, &proc)
      options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
      @label_all = options[:label]
      form_for(record_or_name_or_array, *(args << options), &proc)
    end

    def better_fields_for(record_or_name_or_array, *args, &proc)
      options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
      @label_all = options[:label]
      fields_for(record_or_name_or_array, *(args << options), &proc)
    end

    def label_all?
      @label_all
    end
  end
end
