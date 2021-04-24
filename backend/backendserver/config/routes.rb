Rails.application.routes.draw do
  get 'chatbot/index'
  post 'chatbot/create'
  get 'chatbot/show'
    
  get 'chatbot/acceptReceive'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
