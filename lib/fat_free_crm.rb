# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

# Load Fat Free CRM as a Rails Engine
require 'fat_free_crm/engine'

module FatFreeCRM
  class << self
  end
end

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
