Rails.application.routes.draw do
  get "chat_rooms/show"
  root "home#index"
  devise_for :users ,controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :chat_rooms do
    resources :messages, only: [:create]
    member do
      patch :promote_to_moderator
      post :admin_and_moderator_can_add_new_member
      delete :admin_remove_member
      delete :destroy_group_message
    end
    collection do
      get :new_group
      post :create_private_chat
      post :create_group_chat
    end
  end

end
