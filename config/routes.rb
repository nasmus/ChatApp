Rails.application.routes.draw do
  get "chat_rooms/show"
  root "home#index"
  devise_for :users ,controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :chat_rooms do
    resources :messages, only: [:create]
    collection do
      post :create_private_chat
    end
  end

end
