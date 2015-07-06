# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
# == Schema Information
#
# Table name: fields
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  field_group_id :integer
#  position       :integer
#  pair_id        :integer
#  name           :string(64)
#  label          :string(128)
#  hint           :string(255)
#  placeholder    :string(255)
#  as             :string(32)
#  collection     :text
#  disabled       :boolean
#  required       :boolean
#  maxlength      :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class FatFreeCRM::Field < ActiveRecord::Base
  acts_as_list

  serialize :collection, Array
  serialize :settings, HashWithIndifferentAccess

  belongs_to :field_group, class_name: 'FatFreeCRM::FieldGroup'

  scope :core_fields,   -> { where(type: 'CoreField') }
  scope :custom_fields, -> { where("type != 'CoreField'") }
  scope :without_pairs, -> { where(pair_id: nil) }

  delegate :klass, :klass_name, :klass_name=, to: :field_group

  BASE_FIELD_TYPES = {
    'string'      => { klass: 'FatFreeCRM::CustomField', type: 'string' },
    'text'        => { klass: 'FatFreeCRM::CustomField', type: 'text' },
    'email'       => { klass: 'FatFreeCRM::CustomField', type: 'string' },
    'url'         => { klass: 'FatFreeCRM::CustomField', type: 'string' },
    'tel'         => { klass: 'FatFreeCRM::CustomField', type: 'string' },
    'select'      => { klass: 'FatFreeCRM::CustomField', type: 'string' },
    'radio_buttons'       => { klass: 'FatFreeCRM::CustomField', type: 'string' },
    'check_boxes' => { klass: 'FatFreeCRM::CustomField', type: 'text' },
    'boolean'     => { klass: 'FatFreeCRM::CustomField', type: 'boolean' },
    'date'        => { klass: 'FatFreeCRM::CustomField', type: 'date' },
    'datetime'    => { klass: 'FatFreeCRM::CustomField', type: 'timestamp' },
    'decimal'     => { klass: 'FatFreeCRM::CustomField', type: 'decimal', column_options: { precision: 15, scale: 2 } },
    'integer'     => { klass: 'FatFreeCRM::CustomField', type: 'integer' },
    'float'       => { klass: 'FatFreeCRM::CustomField', type: 'float' }
  }.with_indifferent_access

  validates_presence_of :label, message: "^Please enter a field label."
  validates_length_of :label, maximum: 64, message: "^The field name must be less than 64 characters in length."
  validates_numericality_of :maxlength, only_integer: true, allow_blank: true, message: "^Max size can only be whole number."
  validates_presence_of :as, message: "^Please specify a field type."
  validates_inclusion_of :as, in: proc { field_types.keys }, message: "^Invalid field type.", allow_blank: true

  def column_type(field_type = as)
    (opts = FatFreeCRM::Field.field_types[field_type]) ? opts[:type] : fail("Unknown field_type: #{field_type}")
  end

  def input_options
    input_html = {}
    attributes.reject do |k, v|
      !%w(as collection disabled label placeholder required maxlength).include?(k) || v.blank?
    end.symbolize_keys.merge(input_html)
  end

  def collection_string=(value)
    self.collection = value.split("|").map(&:strip).reject(&:blank?)
  end

  def collection_string
    collection.try(:join, "|")
  end

  def render_value(object)
    render object.send(name)
  end

  def render(value)
    case as
    when 'checkbox'
      value.to_s == '0' ? "no" : "yes"
    when 'date'
      value && value.strftime(I18n.t("date.formats.mmddyy"))
    when 'datetime'
      value && value.in_time_zone.strftime(I18n.t("time.formats.mmddyyyy_hhmm"))
    when 'check_boxes'
      value.select(&:present?).in_groups_of(2, false).map { |g| g.join(', ') }.join("<br />".html_safe) if Array === value
    else
      value.to_s
    end
  end

  protected

  class << self
    # Provides access to registered field_types
    #------------------------------------------------------------------------------
    def field_types
      @@field_types ||= BASE_FIELD_TYPES
    end

    # Register custom fields so they are available to the rest of the app
    # Example options: :as => 'datepair', :type => 'date', :klass => 'CustomFieldDatePair'
    #------------------------------------------------------------------------------
    def register(options)
      opts = options.dup
      as = options.delete(:as)
      (@@field_types ||= BASE_FIELD_TYPES).merge!(as => options)
    end

    # Returns class name given a key
    #------------------------------------------------------------------------------
    def lookup_class(as)
      (@@field_types ||= BASE_FIELD_TYPES)[as][:klass]
    end
  end

  ActiveSupport.run_load_hooks(:fat_free_crm_field, self)
end
