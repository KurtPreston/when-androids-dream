Rails.application.routes.draw do
  resources :generated_images, path: '/'
  resources :source_images
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
