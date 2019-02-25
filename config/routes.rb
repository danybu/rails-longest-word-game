Rails.application.routes.draw do
  root to: 'game_questions#new'
  get 'new', to: 'game_questions#new', as: :new
  post 'score', to: 'game_questions#score', as: :score
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
