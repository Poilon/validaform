# Validaform
Rails API form validator

## Usage

Mount to an endpoint of your application, give it forms fields, and it'll return the validations errors/success in JSON.
Really usefull when you want to add on-unblur or before-submit validations.

You post on `/validaform/forms/validate` a json with this format :

```
{
  fields: [
    { name: 'users/username', value: 'Asterixlegaulois' },
    { name: 'company/name', value: 'Panoracorp' }
  ]
}.to_json
```

and the API will send you the validation errors like
```
{
  fields:[
    {
      name: 'users/first_name',
      errors: ['too_long', 'too_great_album'],
      count: 2
    },
    {
      name: 'company/name',
      errors: ['taken'],
      count: 1
    }
  ],
  count: 3
}
```

example with curl =>

```
curl -X POST -H 'Content-Type: application/json' -d '{"fields":[{"name":"users/first_name","value":"Asterix"},  {"name":"users/last_name","value":"LeGaulois"}, {"name":"companies/size", "value":"17"}]}' http://localhost:3000/validaform/forms/validate
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'validaform'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install validaform
```

Then at last, add
```mount Validaform::Engine, at: '/validaform'```
inside your
`Rails.application.routes.draw` block of your `route.rb`

## Contributing
### TODO
  -> Add tests

  -> Check security

  -> More explanations in README
  
### Pull-requests
  Please fork and make a pull-request, I'll be reactive.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
