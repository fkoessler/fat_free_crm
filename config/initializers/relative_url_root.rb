# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
# Set relative url root for assets

if FatFreeCRM::Setting.base_url.present?
  ActionController::Base.relative_url_root = FatFreeCRM::Setting.base_url
end
