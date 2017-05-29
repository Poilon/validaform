$:.push File.expand_path('../lib', __FILE__)

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
  s.description = 'Perform a validation for forms via API call'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.1'

  s.add_development_dependency 'sqlite3'
end
