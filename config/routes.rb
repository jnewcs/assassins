Rails.application.routes.draw do
    devise_for :users

    root 'home#index'

    resources :home do 
        get 'switch',on: :collection  
        get 'reset_all', on: :collection
        get 'pre_reset', on: :collection
        get 'add_hours', on: :member

        get 'pre_change_name', on: :member
        post :change_name, on: :member

        get 'pre_change_phone', on: :member
        post 'change_phone', on: :member

        get 'pre_change_time', on: :member
        post 'change_time', on: :member

        post 'populate', on: :collection
    end
    
end
