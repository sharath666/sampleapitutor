Rails.application.routes.draw do
  #devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    post "users/sign_up"
    post "users/login"
    put "users/logout"
    delete 'booking_slots/:id', to:"booking_slots#destroy"
    get 'user_booking_count_per_day', to:'users#user_booking_count_per_day'
    get 'user_booking_per_day', to:'users#user_booking_per_day'
    get 'users_booking_slot_count', to:"users#users_booking_slot_count"
    post "booking_slots", to:"booking_slots#create"
    patch "booking_slots/:id", to:"booking_slots#update"
  end

end
