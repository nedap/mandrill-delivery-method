# mandrill-delivery-method [![Build Status](https://travis-ci.org/nedap/mandrill-delivery-method.svg)](https://travis-ci.org/nedap/mandrill-delivery-method) [![Code Climate](https://codeclimate.com/repos/54b6705fe30ba0704d01d967/badges/8f71d0bf9c5d29014cf6/gpa.svg)](https://codeclimate.com/repos/54b6705fe30ba0704d01d967/feed) [![Test Coverage](https://codeclimate.com/repos/54b6705fe30ba0704d01d967/badges/8f71d0bf9c5d29014cf6/coverage.svg)](https://codeclimate.com/repos/54b6705fe30ba0704d01d967/feed)
Adds Mandrill as a `delivery_method` for ActionMailer. Depends on Rails.

# Features
`mandrill-delivery-method` currently only supports sending plain text and HTML e-mail. No images or attachments. If you're missing features, we invite you to add them! :-)

# Installation
Add this line to your application's Gemfile:

```
gem 'mandrill-delivery-method'
```

And then execute:

```
$ bundle
```

# Configuration
Configuring the delivery method is easy. In your `application.rb` add:

```ruby
config.action_mailer.delivery_method   = :mandrill
config.action_mailer.mandrill_settings = {
  api_key:    "your-mandrill-api-key",
  subaccount: "some-subaccount" # Optional
}
```

That's it. ActionMailer will now use `mandrill-delivery-method` for e-mail delivery.

# Contributing
This gem is extremely basic, and can be much extended with features. Whenever you're using Mandrill as a delivery method in your Rails app and need more features than this gem offers, we invite you to contribute! Contributing is easy:

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Make your changes
4. Write your tests
5. Commit your changes: `git commit -m 'Add some feature'`
6. Push to the branch: `git push origin my-new-feature`
7. Submit a pull request!
