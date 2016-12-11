Rails.application.routes.draw do

  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource 'preferences', only: [:show, :edit, :update]
  match '/preferences/hide_welcome_note' => 'preferences#hide_welcome_note', :via=>[:get, :post]
  match '/preferences/carrier_selected' => 'preferences#carrier_selected', :via=>[:post]

  match "/shipping-rates" => "rates#shipping_rates", :via => :post 

end
