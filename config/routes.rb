Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'v1' do
    resources :complaint, only: [:create]
    resources :attachments, only: [:show]
    resources :correspondence, only: [:create]
    resources :comment, only: [:create]
    resources :feedback, only: [:create]
  end

  scope 'v2' do
    resources :comment, only: [:create], defaults: { api_version: 'v2' }
    resources :complaint, only: [:create], defaults: { api_version: 'v2' }
    resources :feedback, only: [:create], defaults: { api_version: 'v2' }
    resources :enquiry, only: [:create]
  end

  get '/health', to: 'health#show'
  get '/readiness', to: 'health#readiness'
  resource :metrics, only: [:show]
end
