better_form Readme
==================

A better Rails 3 FormBuilder.

Features:

* Uses partials to put you in control of templating your form fields
* Free Javascript validation using the same validations you specify in your models
* Out of the box support for common cases; fully customizeable if that's how you roll

Why should I use `better_form` over `formtastic` or `simple_form`?

* No DSL; just use the default Rails form helpers
* No fixed ideas about what options or output you want for your fields
* Less features, less code, less complexity; you get DRY fields with DRY validators and nothing more

Links
=====

* Online documentation: [http://rdoc.info/projects/2suggestions/better_form](http://rdoc.info/projects/2suggestions/better_form)
* Source code: [http://github.com/2suggestions/better_form](http://github.com/2suggestions/better_form)
* Bug/Feature tracking: [http://github.com/2suggestions/better_form/issues](http://github.com/2suggestions/better_form/issues)

Installation and Usage
======================

Add `better_form` to your Gemfile and run `bundle install`.

Generate the required initializer and boilerplate form field partial:

    rails generate better_form

Use the `better_form_for` method to create a better form, and add fields using the default Rails form helpers.

Customizing your form fields
============================

Modify the generated form field partial in `app/views/better_form/_field.html.erb`. Or, create your own from scratch using whatever templating engine you prefer - it's just a regular partial.

A few ideas to get you in the mood:

    # Epic error messages
    <%= field[:field] %>
    <%= error_messages.each do |message| %>
      <h1 class="fail">OH NOES! <%= message %></h1>
    <% end %>

    # Floated field descriptions
    <div class="form_field">
      <%= field[:field] %>
      <div class="description float-right"><%= field[:description] -%></div>
    </div>

    # All the bells and whistles
    <div class="better_form_field <%= 'invalid' if error_messages %>">
      <div class="field">
        <% if field[:prefix] %>
          <span class="field_prefix"><%= field[:prefix] %></span>
        <% end %>
        <%= field[:field] %>
        <% if field[:suffix] %>
          <span class="field_suffix"><%= field[:suffix] %></span>
        <% end %>
        <% if field[:description] %>
          <br>
          <span class="field_description"><%= field[:description] %></span>
        <% end %>
      </div>
      <%= if error_messages %>
        <span class="error_header">Oops!</span>
        <div class="field_errors">
          <%= error_messages.each do |message| %>
            <p class="error_message">
              <%= image_tag('warning_small') %>
              <%= message %>
            </p>
          <% end %>
        </div>
      </div>
    </div>

Have a look at `app/views/better_form/_field.html.erb` to get started.

Built-in options
================

Validations
-----------

Fields can automatically have validation data generated for them using the validations defined in your models:

    class User < ActiveRecord::Base
      validates :name, :presence => true
    end

    <%= f.text_field :name %>

    <label for='user_name'>What shall we call you?</label>
    <input type='text' id='user_name' name='user[name]' data-validates-presence="Name is required" />

Setting a custom error message will be reflected in the validation that is generated:

    validates :name, :presence => { :message => 'Please enter your full name' }

    <input type='text' id='user_name' name='user[name]' data-validates-presence="Please enter your full name" />

Validations are enabled by default. They can be enabled or disabled for a form, or for particular fields:

    # Don't generate validations for this form, unless instructed to for specific fields
    <%= better_form_for @user, :validate => false do |f| %>
      <%= f.text_field :name %>
      <%= f.text_field :password, :validate => true %>

Labels
------

Fields can automatically have label text generated for them, with the label text defaulting to the attribute that the field is for:

    <%= f.text_field :name %>

    <label for='user_name'>Name</label>
    <input type='text' id='user_name' name='user[name]' />

To specify your own label text, pass a string as the `:label` option:

    <%= f.text_field :name, :label => "What shall we call you?" %>

    <label for='user_name'>What shall we call you?</label>
    <input type='text' id='user_name' name='user[name]' />

To skip label generation for a specific field, pass `false` as the `:label` option:

    <%= f.text_field :name, :label => false %>

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
