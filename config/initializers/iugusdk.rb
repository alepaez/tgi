IuguSDK.setup do |config|
  config.app_main_url = '/app'
  config.application_title = 'tgi-crm'

  config.enable_account_alias = false
  config.enable_custom_domain = false
  config.enable_social_login = false
  config.enable_social_linking = false
  config.enable_user_confirmation = false
  config.enable_email_reconfirmation = true
  config.enable_subscription_features = false
  config.enable_account_api = false
  #config.account_api_tokens = ['TEST', 'LIVE']
  config.enable_user_api = true
  config.delay_account_exclusion = 180
  config.delay_user_exclusion = 180
  config.enable_welcome_mail = true
  config.enable_account_cancel = false
  config.enable_user_cancel = false

  # TODO: Habilitar na 2a fase
  config.enable_guest_user = false
  config.enable_multiple_users_per_account = true
  config.enable_multiple_accounts = false

  # config.alternative_layout = 'forms'

  # Application Host
  config.application_main_host = 'tgi-crm.dev'
  config.application_main_host = 'tgi-crm.com' if Rails.env.production?

  config.iws_api_key = "77c779f7946750903e755b32b811d94b"

  config.private_api_secret = "7d3833286fba00cf70a186e4205d3a41"
end
