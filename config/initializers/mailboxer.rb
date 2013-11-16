Mailboxer.setup do |config|

  #Configures if you applications uses or no the email sending for Notifications and Messages
  config.uses_emails = true

  #Configures the default from for the email sent for Messages and Notifications of Mailboxer
  config.default_from = DEFAULT_FROM
  

  #Configures the methods needed by mailboxer
  config.email_method = :message_notify
  config.name_method = :fullname

  #Configures if you use or not a search engine and wich one are you using
  #Supported enignes: [:solr,:sphinx]
  config.search_enabled = false
  config.search_engine = :solr
end
