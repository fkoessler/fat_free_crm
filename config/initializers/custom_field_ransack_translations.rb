# Load field names for custom fields, for Ransack search
# if FatFreeCRM::Setting.database_and_table_exists?
#   Rails.application.config.after_initialize do
#     I18n.backend.load_translations
#
#     translations = { ransack: { attributes: {} } }
#     FatFreeCRM::CustomField.find_each do |custom_field|
#       if custom_field.field_group.present?
#         model_key = custom_field.klass.model_name.singular
#         translations[:ransack][:attributes][model_key] ||= {}
#         translations[:ransack][:attributes][model_key][custom_field.name] = custom_field.label
#       end
#     end
#
#     I18n.backend.store_translations(FatFreeCRM::Setting.locale.to_sym, translations)
#   end
# end
