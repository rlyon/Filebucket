Filebucket::Application.routes.draw do
  resources :folders
  resources :assets
  resources :shared_folders
  resources :public_folders
  resources :invites
  resources :access_keys
  resources :keyed_folders, :except => [:index]
  resources :key_sessions
  
  devise_for :users
  
  get "/keyauth/login" => "key_sessions#new", :as => "keyauth_login"
  get "/keyauth/logout" => "key_sessions#destroy", :as => "keyauth_logout"
  get "/keyauth/folders" => "key_sessions#index", :as => "keyauth_folders" 
  
  match "download/:id" => "assets#get", :as => "download"
  match "download_folder/:id" => "folders#get", :as => "download_folder"
   
  match "folders/share" => "folders#share"
  match "folders/unshare" => "folders#unshare"
  match "folders/notify" => "folders#notify"

  match "assets/new/:folder_id" => "assets#new", :as => "new_sub_asset"
  match "folders/new/:folder_id" => "folders#new", :as => "new_sub_folder"

  match "publicize/:id" => "public_folders#update", :as => "publicize"
  
  root :to => "folders#index"
end
