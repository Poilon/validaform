require 'validaform/engine'

module Validaform
  class Base

    attr_reader :fields
    attr_accessor :status_code

    def initialize(params:)
      @fields = params.permit(fields: %i[name value]).to_h[:fields]
      @status_code = 200
    end

    # fields =>
    # [
    #   { name: 'users/first_name', value: 'Asterix' }
    # ]
    # errors will return
    # {
    #   fields:[
    #     {
    #       name: 'users/first_name',
    #       errors: ['too_short', 'too_long'],
    #       count: 2
    #     }
    #   ],
    #   count: 2
    # }
    def errors
      errors_hash = { fields: [] }
      parse_fields.map do |resource, fields|
        resource_class = resource_class(resource)
        dev_errors = handle_development_errors(resource, resource_class, fields)
        return dev_errors if dev_errors.present?
        generate_errors_hash(resource, resource_class, fields, errors_hash)
      end
      errors_hash[:count] = total_errors_count(errors_hash)
      errors_hash
    end

    private

    # fields =>
    # [
    #   { name: 'users/first_name', value: 'Asterix' },
    #   { name: 'users/last_name', value: 'LeGaulois' },
    #   { name: 'companies/name', value: 'PotionCorp' }
    # ]
    # parse_field transforms it to
    #
    #  {
    #    users: {
    #      first_name: 'Asterix',
    #      last_name: 'LeGaulois'
    #    },
    #    companies: { name: 'PotionCorp' }
    #  }
    def parse_fields
      fields.each_with_object({}) do |f, h|
        h[f[:name].split('/').first] ||= {}
        h[f[:name].split('/').first][f[:name].split('/').last] = f[:value]
      end
    end

    # Count the global errors count
    def total_errors_count(errors_hash)
      errors_hash[:fields].map { |h| h[:count] }.reduce(:+) || 0
    end

    # Get the model class of the given resource
    # Ex:
    # $ resource_class('users')
    # => User
    def resource_class(resource)
      resource.classify.constantize
    rescue NameError
      nil
    end

    def generate_errors_hash(resource, resource_class, fields, errors_hash)
      # Create an instance of it and check if valid with the given attributes
      fetch_object(fields, resource_class).tap(&:valid?).errors.messages.each do |field, errors|
        next unless fields.keys.include?(field.to_s)
        errors_hash[:fields] << {
          name: "#{resource}/#{field}", errors: errors, count: errors.count
        }
      end
    end

    def fetch_object(fields, resource_class)
      return resource_class.new(fields) if fields['id'].blank?
      resource_class.find_by(id: fields['id']).tap { |r| r.attributes = fields }
    end

    def handle_development_errors(resource, klass, fields)
      return not_defined_class_error(resource) if klass.nil?
      return not_db_model_error(resource) unless klass.ancestors.include?(ApplicationRecord)
      invalid_fields = fields.keys - klass.new.attributes.keys
      return invalid_fields_error(invalid_fields) if invalid_fields.present?
      return object_not_found_error(resource) if fields['id'] && !klass.find_by(id: fields['id'])
      nil
    end

    def object_not_found_error(resource)
      @status_code = 400
      { code: 'RESOURCE NOT FOUND', message: "#{resource} not found on database" }
    end

    def not_defined_class_error(resource)
      @status_code = 400
      { code: 'INVALID RESOURCE', message: "#{resource} is not a valid resource" }
    end

    def form_errors_handler(resource)
      @status_code = 400
      { code: 'NOT A DB MODEL', message: "#{resource} is not a DB model" }
    end

    def invalid_fields_error(invalid_fields)
      @status_code = 400
      {
        code: 'INVALID FIELDS',
        message: "\"#{invalid_fields.join(', ')}\" aren't valid model fields"
      }
    end

  end
end
