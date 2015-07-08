# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

# Load Fat Free CRM as a Rails Engine
require 'fat_free_crm/engine'

require 'fat_free_crm/load_settings' # register load hook for Setting

# Require gem dependencies, monkey patches, and vendored plugins (in lib)
require "fat_free_crm/gem_dependencies"
require "fat_free_crm/gem_ext"

require "fat_free_crm/custom_fields" # load hooks for Field
require "fat_free_crm/version"
require "fat_free_crm/core_ext"
require "fat_free_crm/comment_extensions"
require "fat_free_crm/exceptions"
require "fat_free_crm/export_csv"
require "fat_free_crm/errors"
require "fat_free_crm/i18n"
require "fat_free_crm/permissions"
require "fat_free_crm/exportable"
require "fat_free_crm/renderers"
require "fat_free_crm/fields"
require "fat_free_crm/sortable"
require "fat_free_crm/tabs"
require "fat_free_crm/callback"
require "fat_free_crm/view_factory"

require "country_select"
require "gravatar_image_tag"

module FatFreeCRM

  mattr_accessor :user_class, :ability_class

  class << self

    def decorate_user_class!
      FatFreeCRM.user_class.constantize.class_eval do

        before_create :check_if_needs_approval
        before_destroy :check_if_current_user, :check_if_has_related_assets

        has_one :avatar, as: :entity, dependent: :destroy, class_name: 'FatFreeCRM::Avatar'  # Personal avatar.
        has_many :avatars, class_name: 'FatFreeCRM::Avatar'                                  # As owner who uploaded it, ex. Contact avatar.
        has_many :comments, as: :commentable, class_name: 'FatFreeCRM::Comment'              # As owner who created a comment.
        has_many :accounts, class_name: 'FatFreeCRM::Account'
        has_many :campaigns, class_name: 'FatFreeCRM::Campaign'
        has_many :leads, class_name: 'FatFreeCRM::Lead'
        has_many :contacts, class_name: 'FatFreeCRM::Contact'
        has_many :opportunities, class_name: 'FatFreeCRM::Opportunity'
        has_many :assigned_opportunities, class_name: 'FatFreeCRM::Opportunity', foreign_key: 'assigned_to'
        has_many :permissions, dependent: :destroy, class_name: 'FatFreeCRM::Permission'
        has_many :preferences, dependent: :destroy, class_name: 'FatFreeCRM::Preference'
        has_many :lists, class_name: 'FatFreeCRM::List'
        has_and_belongs_to_many :groups, class_name: 'FatFreeCRM::Group'

        has_paper_trail class_name: 'FatFreeCRM::Version', ignore: [:perishable_token]

        scope :by_id, -> { order('id DESC') }
        scope :without, ->(user) { where('id != ?', user.id).by_name }
        scope :by_name, -> { order('first_name, last_name, email') }

        scope :text_search, ->(query) {
          query = query.gsub(/[^\w\s\-\.'\p{L}]/u, '').strip
          where('upper(username) LIKE upper(:s) OR upper(email) LIKE upper(:s) OR upper(first_name) LIKE upper(:s) OR upper(last_name) LIKE upper(:s)', s: "%#{query}%")
        }

        scope :my, -> { accessible_by(User.current_ability) }

        scope :have_assigned_opportunities, -> {
          joins("INNER JOIN fat_free_crm_opportunities ON users.id = fat_free_crm_opportunities.assigned_to")
              .where("fat_free_crm_opportunities.stage <> 'lost' AND fat_free_crm_opportunities.stage <> 'won'")
              .select('DISTINCT(users.id), users.*')
        }

        # Store current user in the class so we could access it from the activity
        # observer without extra authentication query.
        cattr_accessor :current_user

        validates_presence_of :email, message: :missing_email

        #----------------------------------------------------------------------------
        def name
          first_name.blank? ? username : first_name
        end

        #----------------------------------------------------------------------------
        def full_name
          first_name.blank? && last_name.blank? ? email : "#{first_name} #{last_name}".strip
        end

        #----------------------------------------------------------------------------
        def suspended?
          suspended_at != nil
        end

        #----------------------------------------------------------------------------
        def awaits_approval?
          self.suspended? && sign_in_count == 0 && FatFreeCRM::Setting.user_signup == :needs_approval
        end

        #----------------------------------------------------------------------------
        def preference
          @preference ||= preferences.build
        end
        alias_method :pref, :preference

        # Override global I18n.locale if the user has individual local preference.
        #----------------------------------------------------------------------------
        def set_individual_locale
          I18n.locale = preference[:locale] if preference[:locale]
        end

        def to_json(_options = nil)
          [name].to_json
        end

        def to_xml(_options = nil)
          [name].to_xml
        end

        private

        # Suspend newly created user if signup requires an approval.
        #----------------------------------------------------------------------------
        def check_if_needs_approval
          self.suspended_at = Time.now if FatFreeCRM::Setting.user_signup == :needs_approval && !admin
        end

        # Prevent current user from deleting herself.
        #----------------------------------------------------------------------------
        def check_if_current_user
          User.current_user.nil? || User.current_user != self
        end

        # Prevent deleting a user unless she has no artifacts left.
        #----------------------------------------------------------------------------
        def check_if_has_related_assets
          artifacts = %w(FatFreeCRM::Account FatFreeCRM::Campaign FatFreeCRM::Lead FatFreeCRM::Contact FatFreeCRM::Opportunity FatFreeCRM::Comment FatFreeCRM::Task).inject(0) do |sum, asset|
            klass = asset.constantize
            sum += klass.assigned_to(self).count if asset != "FatFreeCRM::Comment"
            sum += klass.created_by(self).count
          end
          artifacts == 0
        end

        # Define class methods
        #----------------------------------------------------------------------------
        class << self
          def current_ability
            Ability.new(FatFreeCRM.user_class.constantize.current_user)
          end

          def can_signup?
            [:allowed, :needs_approval].include? FatFreeCRM::Setting.user_signup
          end
        end

        ActiveSupport.run_load_hooks(:user, self)
      end
    end

  end
end
