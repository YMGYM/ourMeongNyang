Rails.application.routes.draw do
	get 'chatbot/index'
	post 'chatbot/create'
	post 'chatbot/show'
	post 'chatbot/accept'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
