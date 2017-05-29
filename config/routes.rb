Validaform::Engine.routes.draw do

  resources :forms do
    collection do
      post 'validate'
    end
  end

end
