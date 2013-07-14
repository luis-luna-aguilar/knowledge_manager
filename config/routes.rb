KnoledgeApp::Application.routes.draw do
  resources :articles
  resources :tags
  match "/tags_unique_names" => "tags#unique_names"
  resources :knowledge_pieces
  resources :searches
  root to: "searches#new"
end
