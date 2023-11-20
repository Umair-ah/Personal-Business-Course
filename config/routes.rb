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
        delete :remove_video
        patch :update_position
      end
    end
  end
end
