# Be sure to restart your server when you modify this file.

if defined?(FatFreeCRM::Application)
  Rails.application.config.session_store :cookie_store, key: '_fat_free_crm_session'
end
