KnoledgeApp::Application.routes.draw do
  resources :articles
  resources :tags
  resources :knowledge_pieces
  root to: "home#index"
end
