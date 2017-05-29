module Validaform
  class FormsController < Validaform::ApplicationController

    skip_before_action :verify_authenticity_token

    # curl -X POST -H 'Content-Type: application/json' -d \
    # '{"fields":[{"name":"users/first_name","value":"Asterix"},
    # {"name":"users/last_name","value":"LeGaulois"}, {"name":"companies/size", "value":"17"}]}' \
    # http://localhost:3000/validaform/forms/validate
    def validate
      validator = Validaform::Base.new(params: params)
      render json: validator.errors, status: validator.status_code
    end

  end
end
