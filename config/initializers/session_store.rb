# Rails.application.config.session_store :cookie_store,
#   key: "_text_to_speech_session",
#   same_site: :none,
#   secure: false

Rails.application.config.session_store :cookie_store,
  key: "_text_to_speech_session",
  same_site: :none,
  secure: Rails.env.production?