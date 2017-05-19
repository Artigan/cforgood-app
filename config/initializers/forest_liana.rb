ForestLiana.env_secret = Rails.application.secrets.forest_env_secret
ForestLiana.auth_secret = Rails.application.secrets.forest_auth_secret

ForestLiana.integrations = {
  intercom: {
    app_id: ENV['INTERCOM_API_ID'],
    api_key: ENV['INTERCOM_API_KEY'],
    mapping: 'User'
  }
}
