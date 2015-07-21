# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class FatFreeCRM::ApplicationController < ::ApplicationController
  protect_from_forgery

  before_action :set_context
  before_action :clear_setting_cache
  before_action "hook(:app_before_filter, self)"
  after_action "hook(:app_after_filter,  self)"

  helper_method :called_from_index_page?, :called_from_landing_page?
  helper_method :klass

  #I had to include the helpers manually, but normally
  # helpers should be included automatically in Rails4..
  helper FatFreeCRM::AccountsHelper
  helper FatFreeCRM::AddressesHelper
  helper FatFreeCRM::AuthenticationsHelper
  helper FatFreeCRM::CampaignsHelper
  helper FatFreeCRM::ContactsHelper
  helper FatFreeCRM::EmailsHelper
  helper FatFreeCRM::FieldsHelper
  helper FatFreeCRM::GroupsHelper
  helper FatFreeCRM::HomeHelper
  helper FatFreeCRM::LeadsHelper
  helper FatFreeCRM::ListsHelper
  helper FatFreeCRM::OpportunitiesHelper
  helper FatFreeCRM::PasswordsHelper
  helper FatFreeCRM::RemoteLinkPaginationHelper
  helper FatFreeCRM::TagsHelper
  helper FatFreeCRM::TasksHelper
  helper UsersHelper
  helper FatFreeCRM::VersionsHelper
  helper FatFreeCRM::JavascriptHelper
  helper FatFreeCRM::CommentsHelper

  respond_to :html, only: [:index, :show, :auto_complete]
  respond_to :js
  respond_to :json, :xml, except: :edit
  respond_to :atom, :csv, :rss, :xls, only: :index

  rescue_from ActiveRecord::RecordNotFound, with: :respond_to_not_found
  rescue_from CanCan::AccessDenied,         with: :respond_to_access_denied

  include ERB::Util # to give us h and j methods

  # Common auto_complete handler for all core controllers.
  #----------------------------------------------------------------------------
  def auto_complete
    @query = params[:auto_complete_query] || ''
    @auto_complete = hook(:auto_complete, self, query: @query, user: current_user)
    if @auto_complete.empty?
      exclude_ids = auto_complete_ids_to_exclude(params[:related])
      @auto_complete = klass.my.text_search(@query).search(id_not_in: exclude_ids).result.limit(10)
    else
      @auto_complete = @auto_complete.last
    end

    session[:auto_complete] = controller_name.to_sym
    respond_to do |format|
      format.any(:js, :html)   { render partial: 'auto_complete' }
      format.json do
        render json: @auto_complete.inject({}){|h, a|
                       h[a.id] = a.respond_to?(:full_name) ? h(a.category + ' - ' + a.full_name) : h(a.category + ' - ' + a.name); h
                     }
      end
    end
  end

  private

  #
  # In rails 3, the default behaviour for handle_unverified_request is to delete the session
  # and continue executing the request. However, we use cookie based authentication and need
  # to halt proceedings. In Rails 4, use "protect_from_forgery with: :exception"
  # See http://blog.nvisium.com/2014/09/understanding-protectfromforgery.html for more details.
  #----------------------------------------------------------------------------
  def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken
  end

  #
  # Takes { :related => 'campaigns/7' } or { :related => '5' }
  #   and returns array of object ids that should be excluded from search
  #   assumes controller_name is a method on 'related' class that returns a collection
  #----------------------------------------------------------------------------
  def auto_complete_ids_to_exclude(related)
    return [] if related.blank?
    return [related.to_i].compact unless related.index('/')
    related_class, id = related.split('/')
    related_class = 'fat_free_crm/' + related_class unless Object.const_defined?(related_class.classify)
    obj = related_class.classify.constantize.find_by_id(id)
    if obj && obj.respond_to?(controller_name)
      obj.send(controller_name).map(&:id)
    else
      []
    end
  end

  #----------------------------------------------------------------------------
  def klass
    @klass ||= controller_path.classify.constantize
  end

  #----------------------------------------------------------------------------
  def clear_setting_cache
    FatFreeCRM::Setting.clear_cache!
  end

  #----------------------------------------------------------------------------
  def set_context
    Time.zone = ActiveSupport::TimeZone[session[:timezone_offset]] if session[:timezone_offset]
    if current_user.present? && (locale = current_user.preference[:locale]).present?
      I18n.locale = locale
    elsif FatFreeCRM::Setting.locale.present?
      I18n.locale = FatFreeCRM::Setting.locale
    end
  end

  #----------------------------------------------------------------------------
  def set_current_tab(tab = controller_name)
    @current_tab = tab
  end

  #----------------------------------------------------------------------------
  def require_user
    unless current_user
      store_location
      flash[:notice] = t(:msg_login_needed) if request.fullpath != "/"
      respond_to do |format|
        format.html { redirect_to login_url }
        format.js   { render text: "window.location = '#{login_url}';" }
      end
    end
  end

  #----------------------------------------------------------------------------
  def require_no_user
    if current_user
      store_location
      flash[:notice] = t(:msg_logout_needed)
      redirect_to profile_url
    end
  end

  #----------------------------------------------------------------------------
  def store_location
    session[:return_to] = request.fullpath
  end

  #----------------------------------------------------------------------------
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  #----------------------------------------------------------------------------
  def can_signup?
    User.can_signup?
  end

  #----------------------------------------------------------------------------
  def called_from_index_page?(controller = controller_name)
    if controller != "tasks"
      request.referer =~ %r{/#{controller}$}
    else
      request.referer =~ /tasks\?*/
    end
  end

  #----------------------------------------------------------------------------
  def called_from_landing_page?(controller = controller_name)
    request.referer =~ %r{/#{controller}/\w+}
  end

  # Proxy current page for any of the controllers by storing it in a session.
  #----------------------------------------------------------------------------
  def current_page=(page)
    p = page.to_i
    @current_page = session[:"#{controller_name}_current_page"] = (p.zero? ? 1 : p)
  end

  #----------------------------------------------------------------------------
  def current_page
    page = params[:page] || session[:"#{controller_name}_current_page"] || 1
    @current_page = page.to_i
  end

  # Proxy current search query for any of the controllers by storing it in a session.
  #----------------------------------------------------------------------------
  def current_query=(query)
    if session[:"#{controller_name}_current_query"].to_s != query.to_s # nil.to_s == ""
      self.current_page = params[:page] # reset paging otherwise results might be hidden, defaults to 1 if nil
    end
    @current_query = session[:"#{controller_name}_current_query"] = query
  end

  #----------------------------------------------------------------------------
  def current_query
    @current_query = params[:query] || session[:"#{controller_name}_current_query"] || ''
  end

  #----------------------------------------------------------------------------
  def asset
    controller_name.singularize
  end

  #----------------------------------------------------------------------------
  def respond_to_not_found(*_types)
    flash[:warning] = t(:msg_asset_not_available, asset)

    respond_to do |format|
      format.html { redirect_to(redirection_url) }
      format.js   { render text: 'window.location.reload();' }
      format.json { render text: flash[:warning],  status: :not_found }
      format.xml  { render xml: [flash[:warning]], status: :not_found }
    end
  end

  #----------------------------------------------------------------------------
  def respond_to_related_not_found(related, *_types)
    asset = "note" if asset == "comment"
    flash[:warning] = t(:msg_cant_create_related, asset: asset, related: related)

    url = send("#{related.pluralize}_path")
    respond_to do |format|
      format.html { redirect_to(url) }
      format.js   { render text: %(window.location.href = "#{url}";) }
      format.json { render text: flash[:warning],  status: :not_found }
      format.xml  { render xml: [flash[:warning]], status: :not_found }
    end
  end

  #----------------------------------------------------------------------------
  def respond_to_access_denied
    flash[:warning] = t(:msg_not_authorized, default: 'You are not authorized to take this action.')
    respond_to do |format|
      format.html { redirect_to(redirection_url) }
      format.js   { render text: 'window.location.reload();' }
      format.json { render text: flash[:warning],  status: :unauthorized }
      format.xml  { render xml: [flash[:warning]], status: :unauthorized }
    end
  end

  #----------------------------------------------------------------------------
  def redirection_url
    # Try to redirect somewhere sensible. Note: not all controllers have an index action
    url = if current_user.present?
            (respond_to?(:index) && action_name != 'index') ? { action: 'index' } : root_url
          else
            login_url
    end
  end
end
