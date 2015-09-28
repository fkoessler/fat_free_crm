# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class FatFreeCRM::TaskMailer < ActionMailer::Base

  include ActionView::Helpers::UrlHelper
  include FatFreeCRM::TasksHelper
  default from: 'intranet@fahrner.fr'

  def task_details(task, view, user, recipient)
    @name = task.name
    @category = task.category
    @due_at = task.due_at.try(:strftime, '%d/%m/%Y %H:%M') || 'ASAP'
    @username = user.full_name
    @created_by = task.user.full_name
    @created_at = task.created_at
    @completed_by = task.completor.try(:full_name)
    @completed_at = task.completed_at.try(:strftime, '%d/%m/%Y %H:%M')
    @assigned_to = task.assignee.try(:full_name)
    if task.asset_type == 'FatFreeCRM::Account'
      @has_contact = true
      @contact_name = task.asset.name
      @contact_email = task.asset.email
      @contact_phone = task.asset.phone
      @contact_toll_free_phone = task.asset.toll_free_phone
      @contact_fax = task.asset.fax
    end
    if task.asset_type == 'FatFreeCRM::Contact'
      @has_contact = true
      @contact_name = task.asset.full_name
      @contact_email = task.asset.email
      @contact_alt_email = task.asset.alt_email
      @contact_phone = task.asset.phone
      @contact_mobile = task.asset.mobile
      @contact_fax = task.asset.fax
    end
    @link = link_to_task_index(task, view)
    Rails.logger.debug 'CHECK LINKKK'
    Rails.logger.debug @link

    mail subject: default_i18n_subject(username: @username),
         to: recipient
  end
end
