Filebox::Application.routes.draw do
  resources :folders
  resources :assets
  resources :shared_folders

  devise_for :users
  
  match "download/:id" => "assets#get", :as => "download"
  
  match "public/:folder_id" => "folders#browse", :as => "public"
  
  match "browse/:folder_id" => "home#browse", :as => "browse"
  match "browse/:folder_id/new_folder" => "folders#new", :as => "new_sub_folder"
  match "browse/:folder_id/new_file" => "assets#new", :as => "new_sub_file"
  match "browse/:folder_id/rename" => "folders#edit", :as => "rename_folder"
   
  match "home/share" => "home#share"
  match "home/unshare" => "home#unshare"
  
  match "publicize/:folder_id" => "folders#publicize", :as => "publicize"
  
  root :to => "home#index"
end
