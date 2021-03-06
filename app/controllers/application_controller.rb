class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  private
    def current_shop
      puts 'current shop'
      return nil unless session[:shopify]
      puts 'session for'
      puts ( session[:shopify_domain].to_s)
      @shop ||= Shop.find_by_url(session[:shopify_domain].to_s)
      @shop
    end
    
    def check_payment

puts 'checking payment'
      if (Rails.env == "production")
        if (!ShopifyAPI::RecurringApplicationCharge.current)
            #place a recurring charge
          charge = ShopifyAPI::RecurringApplicationCharge.create(:name => "Shipping Calculator Application", 
                                                             :price => 15, 
                                                             :test=>(Rails.env != "production"),
                                                             :trial_days => 100,
                                                             :return_url => "http://#{DOMAIN_NAMES[Rails.env]}/confirm_charge")

          redirect_to charge.confirmation_url
        end
      end

    end  
    
    def init_webhooks
      topics = ["app/uninstalled"]

      topics.each do |topic|
        #check if webbook exists
        hooks = ShopifyAPI::Webhook.find(:all, params => {:topic => topic})
        
        if hooks.size > 0
          hooks[0].destrory()
        end
        Rails.logger.debug("+++++ adding webhook" + "http://#{DOMAIN_NAMES[Rails.env]}/webhooks/#{topic}")
        webhook = ShopifyAPI::Webhook.create(:format => "json", :topic => topic, :address => "http://#{DOMAIN_NAMES[Rails.env]}/webhooks/#{topic}")
        raise "======Webhook invalid: #{webhook.errors.to_s}" unless webhook.valid?
      end
    end

      # return the version of theme currently deployed
    def current_deployed_version
      5
    end  
end
