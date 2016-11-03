Rails.application.routes.draw do

  post 'facebook_user_token' => 'facebook_user_token#create'

  get 'users/profile' => 'users#profile'

end
