Rails.application.routes.draw do
  root "dashboard#index"
  devise_for :users
  
  get "dashboard/index"
  get "reports/quotation_pdf"
  get "home/index"
  
  resources :clients
  resources :projects
  resources :quotations do
    member do
      get :approve
      get :reject
      get :send_for_approval
      get :download_pdf
    end
    resources :quotation_items, except: [:show]
  end
  resources :materials
  resources :services

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Public routes that don't require authentication
  get "public/quotation/:id", to: "public#public_quotation", as: :public_quotation
  get "public/qr/:id", to: "public#qr_image", as: :public_qr_image
  get "public/show_qr/:id", to: "public#show_qr", as: :public_show_qr
end
