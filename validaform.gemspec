$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'validaform/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'validaform'
  s.version     = Validaform::VERSION
  s.authors     = ['poilon']
  s.email       = ['poilon@gmail.com']
  s.homepage    = 'https://github.com/Poilon/validaform'
  s.summary     = 'Perform a validation for forms via API call'
  s.description = 'Mount to an endpoint of your application, give it forms fields, ' \
    "and it'll return the validations errors/success in JSON. Really usefull when " \
    'you want to add on-unblur or before-submit validations.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_runtime_dependency 'rails', '~> 5.1', '>= 5.1.1'
end
