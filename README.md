better_form Readme
==================

A Rails 3 gem to build DRY forms with Javascript validation.

* Javascript validates form fields as they are completed, using your `ActiveModel` validators
* Well-placed validation output
* Automatic label generation
* Form field descriptions

Links
=====

* Online documentation: [http://rdoc.info/projects/2suggestions/better_form](http://rdoc.info/projects/2suggestions/better_form)
* Source code: [http://github.com/2suggestions/better_form](http://github.com/2suggestions/better_form)
* Bug/Feature tracking: [http://github.com/2suggestions/better_form/issues](http://github.com/2suggestions/better_form/issues)

Installation and Usage
======================

Add `better_form` to your Gemfile:

    gem 'better_form'

And run the usual `bundle install`.

Use the `better_form_for` method to create a better form:

    = better_form_for @user do |f|

Create fields using the usual Rails methods:

    = f.text_field :name
    = f.email_field :email
    = f.password_field :password

Labels
------

Fields will automatically have labels generated for them, with the label text defaulting to the attribute that the field is for:

    = f.text_field :name

    <label for='user_name'>Name</label>
    <input type='text' id='user_name' name='user[name]' />

To specify your own label text, pass a string as the `:label` option:

    = f.text_field :name, :label => "What shall we call you?"

    <label for='user_name'>What shall we call you?</label>
    <input type='text' id='user_name' name='user[name]' />

To skip label generation for a specific field, pass `false` as the `:label` option:

    = f.text_field :name, :label => false

    <input type='text' id='user_name' name='user[name]' />

You can set the default for the entire form in the same way. Field-level `:label` options will override the default value. For example:

    # Don't generate labels for this form, unless instructed to for a specific field
    = better_form_for @user, :label => false do |f|
      = f.text_field :name
      = f.email_field :email, :label => true
      = f.password_field :password, :label => 'Pick a strong password'

    <input type='text' id='user_name' name='user[name]' />

    <label for='user_email'>Email</label>
    <input type='email' id='user_email' name='user[email]' />

    <label for='user_password'>Pick a strong password</label>
    <input type='password' id='user_password' name='user[password]' />

Validations
-----------

Fields will automatically have validation data generated for them using the validations defined in your models:

    class User < ActiveRecord::Base
      validates :name, :presence => true
    end

    = f.text_field :name

    <label for='user_name'>What shall we call you?</label>
    <input type='text' id='user_name' name='user[name]' data-validates-presence="Name is required" />

Setting a custom error message will be reflected in the validation that is generated:

    validates :name, :presence => { :message => 'Please enter your full name' }

    <input type='text' id='user_name' name='user[name]' data-validates-presence="Please enter your full name" />
