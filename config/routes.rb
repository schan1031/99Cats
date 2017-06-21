Rails.application.routes.draw do

  resources :cats
  resources :cat_rental_requests

  patch 'cat_rental_requests/:id' => 'cat_rental_requests#approve'
  patch 'cat_rental_requests/:id' => 'cat_rental_requests#deny'

end
