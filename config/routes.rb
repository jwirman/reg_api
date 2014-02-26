RegApi::Application.routes.draw do

  post '/' => 'users#create', as: "root"

end
