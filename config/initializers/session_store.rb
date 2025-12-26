Rails.application.config.session_store :cookie_store,
  key: "_tts_session",
  same_site: :none,
  secure: false
