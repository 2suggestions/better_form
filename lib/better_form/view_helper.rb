module BetterForm
  module ViewHelper
    def better_form_for(record_or_name_or_array, *args, &proc)
      options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
      form_for(record_or_name_or_array, *(args << options), &proc)
    end
  end
end
