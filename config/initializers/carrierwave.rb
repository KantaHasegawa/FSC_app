CarrierWave.configure do |config|
  config.fog_provider = 'fog/google'
  config.fog_credentials = {
    provider: 'Google',
    google_project: ENV['GCS_PROJECT'],
    google_json_key_string: ENV['GOOGLE_CREDENTIALS'].as_json
  }
  config.fog_directory = ENV['GCS_BUCKET']
end
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
