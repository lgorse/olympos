Koala::Facebook::OAuth.class_eval do
  def initialize_with_default_settings(*args)
    case args.size
      when 0, 1
        raise "application id and/or secret are not specified in the config" unless FACEBOOK_CONFIG['app_id'] && FACEBOOK_CONFIG['app_secret']
        initialize_without_default_settings(FACEBOOK_CONFIG['app_id'].to_s, FACEBOOK_CONFIG['app_secret'].to_s, args.first)
      when 2, 3
        initialize_without_default_settings(*args) 
    end
  end 

  alias_method_chain :initialize, :default_settings 
end
