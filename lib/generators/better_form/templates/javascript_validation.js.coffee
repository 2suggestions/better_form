$ ->
  validators = ['data-validates-numericality', 'data-validates-presence', 'data-validates-format']
  validators_selector = jQuery.map(validators, (n, i) -> "[#{n}]").join(", ")

  $(validators).each (index, attr) ->
    selector = '[' + attr + ']'
    $(selector).live 'keyup', (e) -> validate(this, e, false, attr)
    $(selector).live 'blur', (e) -> validate(this, e, false, attr)

  validate = (field, e, forceValidation, validator) ->
    # Don't validate the field if the keyup was backspace, tab, shift or delete
    return if (e.keyCode == 8 or e.keyCode == 9 or e.keyCode == 16 or e.keyCode == 46) and !$(field).hasClass('invalid')

    switch validator
      when 'data-validates-presence'
        valid = validatePresence(field)
      when 'data-validates-numericality'
        valid = validateNumericality(field)
      when 'data-validates-format'
        valid = validateFormat(field)

    if valid
      removeErrorMessage(field, validator)
      $(field).removeClass('invalid')
      $(field).removeClass('invalidOnSubmit')
      $(field).nextAll('span.error_message').remove()
    else
      $(field).addClass('invalid')

  validatePresence = (field) ->
    if (/^\s*$/.test($(field).val()))
      false
    else
      true

  validateNumericality = (field) ->
    if (isNaN($(field).val()) or (/^\s*$/.test($(field).val())))
      if (!$(field).hasClass('invalid'))
        addErrorMessage(field, 'data-validates-numericality')
      false
    else
      true

  validateFormat = (field) ->
    # Create a new RegExp using the data-validates-format-with string, stripping off the leading and trailing forward slashes
    regexp = new RegExp($(field).data('validates-format-with').slice(1, -1))
    console.log($(field).val())
    if (regexp.test($(field).val()))
      true
    else
      if (!$(field).hasClass('invalid'))
        addErrorMessage(field, 'data-validates-format')
      false

  addErrorMessage = (field, validator) ->
    $(field).closest('span').after('<span class="error_message">' + $(field).attr(validator) + '</span>')

  removeErrorMessage = (field, validator) ->
    $(field).closest('span').next('span.error_message').remove()

  $('form.better_form').submit ->
    $(validators).each (index, attr) ->
      $('[' + attr + ']:visible').each (i, field) ->
        $(field).trigger('blur')

    # If there were one or more invalid inputs, don't submit the form
    if ($(this).find(':input.invalid:visible').filter(validators_selector).length)
      $(this).find('input[type=submit]')
        .css({ position : 'relative' })
        .animate({ left : '-10px' }, 90)
        .animate({ left : '10px' }, 90)
        .animate({ left : '-10px' }, 90)
        .animate({ left : '10px' }, 90)
        .animate({ left : '-10px' }, 90)
        .animate({ left : '0px' }, 90)
      $(this).find(':input.invalid:visible').addClass('invalidOnSubmit')
      return false
    else
      return true
