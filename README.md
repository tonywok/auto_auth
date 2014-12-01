# AutoAuth

A simple and sane rails authentication generator.

Generates roughly the following:
```
app/
    models/
        concerns/
            token_verification.rb
        user.rb
        identity.rb
        registration.rb
    controllers/
        concerns/
            authentication.rb
        sessions_controller.rb
        registrations_controller.rb
        passwords_controller.rb
    mailers
        identity_mailer.rb
    views
        passwords/
            edit.html.erb
            new.html.erb
        sessions/
            new.html.erb
        registrations/
            new.html.erb
        identity_mailer/
            confirm_email.html.erb
            reset_password.html.erb
      config/
          locales/
              auto_auth.en.yml

```

## Installation

I wouldn't add this to my gemfile, since it's really only meant to be run once. Instead, do `gem install auto_auth`

And then execute:

    $ rails generate auto_auth:install

## Usage

By default I have my domain model named `User` and my identity model named `Identity`. You can customize this by passing `--domain_model` and `--identity_model` to the rails generator.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/auto_auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
