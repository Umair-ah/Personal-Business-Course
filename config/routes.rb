Rails.application.routes.draw do
  devise_for :users
  

  root "courses#index"
  get "/my-courses", to: "statics#home"

  resources :courses do
    member do
      delete :remove_thumbnail
    end

    resources :payments do
      collection do
        get :success
      end
    end

    resources :tuts do
      member do 
        resources :single_tut
        patch :update_position
        get "/edit-file-name/:blob_id", to: "tuts#edit_filename", as: "edit_filename"
        post "/edit-file-name/:blob_id", to: "tuts#edit_filename_post", as: "edit_filename_post"
        delete "/delete-file/:blob_id", to: "tuts#delete_file_post", as: "delete_file_post"
        delete "/remove-video/:blob_id", to: "tuts#remove_video", as: "remove_video"

      end
    end
  end

  get "/edit-file-name/:blob_id", to: "tuts#edit_filename", as: "edit_filename"
  post "/edit-file-name/:blob_id", to: "tuts#edit_filename_post", as: "edit_filename_post"

end
