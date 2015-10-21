# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class FatFreeCRM::ContactsController < FatFreeCRM::EntitiesController
  before_action :get_accounts, only: [:new, :create, :edit, :update]

  # GET /contacts
  #----------------------------------------------------------------------------
  def index
    @contacts = get_contacts(page: params[:page], per_page: params[:per_page])

    respond_with @contacts do |format|
      format.xls { render layout: 'fat_free_crm/header' }
      format.csv { render csv: @contacts }
    end
  end

  # GET /contacts/1
  # AJAX /contacts/1
  #----------------------------------------------------------------------------
  def show
    @stage = FatFreeCRM::Setting.unroll(:opportunity_stage)
    @comment = FatFreeCRM::Comment.new
    @timeline = timeline(@contact)
    respond_with(@contact)
  end

  # GET /contacts/new
  #----------------------------------------------------------------------------
  def new
    @contact.attributes = { user: current_user, access: FatFreeCRM::Setting.default_access, assigned_to: nil }
    @account = FatFreeCRM::Account.new(user: current_user)

    if params[:related]
      model, id = params[:related].split('_')
      model = 'fat_free_crm/' + model unless Object.const_defined?(model.classify)
      if related = model.classify.constantize.my.find_by_id(id)
        instance_variable_set("@#{model.sub!('fat_free_crm/', '')}", related)
      else
        respond_to_related_not_found(model) && return
      end
    end

    respond_with(@contact)
  end

  # GET /contacts/1/edit                                                   AJAX
  #----------------------------------------------------------------------------
  def edit
    @account = @contact.account || FatFreeCRM::Account.new(user: current_user)
    if params[:previous].to_s =~ /(\d+)\z/
      @previous = FatFreeCRM::Contact.my.find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i
    end

    respond_with(@contact)
  end

  # POST /contacts
  #----------------------------------------------------------------------------
  def create
    @comment_body = params[:comment_body]
    respond_with(@contact) do |_format|
      if @contact.save_with_account_and_permissions(params.permit!)
        @contact.add_comment_by_user(@comment_body, current_user)
        @contacts = get_contacts if called_from_index_page?
      else
        unless params[:account][:id].blank?
          @account = FatFreeCRM::Account.find(params[:account][:id])
        else
          if request.referer =~ /\/accounts\/(\d+)\z/
            @account = FatFreeCRM::Account.find(Regexp.last_match[1]) # related account
          else
            @account = FatFreeCRM::Account.new(user: current_user)
          end
        end
        @opportunity = FatFreeCRM::Opportunity.my.find(params[:opportunity]) unless params[:opportunity].blank?
      end
    end
  end

  # PUT /contacts/1
  #----------------------------------------------------------------------------
  def update
    respond_with(@contact) do |_format|
      unless @contact.update_with_account_and_permissions(params.permit!)
        if @contact.account
          @account = @contact.account
        else
          @account = FatFreeCRM::Account.new(user: current_user)
        end
      end
    end
  end

  # DELETE /contacts/1
  #----------------------------------------------------------------------------
  def destroy
    @contact.destroy

    respond_with(@contact) do |format|
      format.html { respond_to_destroy(:html) }
      format.js   { respond_to_destroy(:ajax) }
    end
  end

  # PUT /contacts/1/attach
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :attach

  # POST /contacts/1/discard
  #----------------------------------------------------------------------------
  # Handled by EntitiesController :discard

  # POST /contacts/auto_complete/query                                     AJAX
  #----------------------------------------------------------------------------
  # Handled by ApplicationController :auto_complete

  # GET /contacts/redraw                                                   AJAX
  #----------------------------------------------------------------------------
  def redraw
    current_user.pref[:contacts_per_page] = params[:per_page] if params[:per_page]

    # Sorting and naming only: set the same option for Leads if the hasn't been set yet.
    if params[:sort_by]
      current_user.pref[:contacts_sort_by] = FatFreeCRM::Contact.sort_by_map[params[:sort_by]]
      if FatFreeCRM::Lead.sort_by_fields.include?(params[:sort_by])
        current_user.pref[:leads_sort_by] ||= FatFreeCRM::Lead.sort_by_map[params[:sort_by]]
      end
    end
    if params[:naming]
      current_user.pref[:contacts_naming] = params[:naming]
      current_user.pref[:leads_naming] ||= params[:naming]
    end

    @contacts = get_contacts(page: 1, per_page: params[:per_page]) # Start on the first page.
    set_options # Refresh options

    respond_with(@contacts) do |format|
      format.js { render :index }
    end
  end

  private

  #----------------------------------------------------------------------------
  alias_method :get_contacts, :get_list_of_records

  #----------------------------------------------------------------------------
  def get_accounts
    @accounts = FatFreeCRM::Account.my.order('name')
  end

  def set_options
    super
    @naming = (current_user.pref[:contacts_naming]   || FatFreeCRM::Contact.first_name_position) unless params[:cancel].true?
  end

  #----------------------------------------------------------------------------
  def respond_to_destroy(method)
    if method == :ajax
      if called_from_index_page?
        @contacts = get_contacts
        if @contacts.blank?
          @contacts = get_contacts(page: current_page - 1) if current_page > 1
          render(:index) && return
        end
      else
        self.current_page = 1
      end
      # At this point render destroy.js
    else
      self.current_page = 1
      flash[:notice] = t(:msg_asset_deleted, @contact.full_name)
      redirect_to contacts_path
    end
  end
end
