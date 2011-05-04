Filebox::Application.routes.draw do
  resources :folders
  resources :assets
  resources :shared_folders
  resources :public_folders
  #resources :home

  devise_for :users
  
  match "download/:id" => "assets#get", :as => "download"
   
  match "folders/share" => "folders#share"
  match "folders/unshare" => "folders#unshare"

  match "assets/new/:folder_id" => "assets#new", :as => "new_sub_asset"

  match "publicize/:id" => "public_folders#update", :as => "publicize"
  
  root :to => "folders#index"
end
