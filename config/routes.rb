Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  namespace :webhooks, constraints: { format: 'json' } do
    namespace :v1 do
      resources :events, only: :create
    end
  end

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :issues, only: [], param: :number  do
        resources :events, only: :index, module: :issues
      end
    end
  end
end
