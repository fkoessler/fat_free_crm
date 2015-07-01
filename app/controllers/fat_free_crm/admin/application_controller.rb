# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class FatFreeCRM::Admin::ApplicationController < FatFreeCRM::ApplicationController
  before_action :require_admin_user

  layout "admin/application"
  helper "fat_free_crm/admin/field_groups"

  # Autocomplete handler for all admin controllers.
  #----------------------------------------------------------------------------
  def auto_complete
    @query = params[:auto_complete_query]
    @auto_complete = klass.text_search(@query).limit(10)
    render partial: 'auto_complete'
  end

  private

  #----------------------------------------------------------------------------
  def require_admin_user
    require_user
    if current_user && !current_user.admin?
      flash[:notice] = t(:msg_require_admin)
      redirect_to root_path
    end
  end
end
