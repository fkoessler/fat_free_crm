# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCRM
  class Tabs
    cattr_accessor :main
    cattr_accessor :admin

    # Class methods.
    #----------------------------------------------------------------------------
    class << self
      def main
        @@main ||= (FatFreeCRM::Setting[:tabs] && FatFreeCRM::Setting[:tabs].dup)
      end

      def admin
        @@admin ||= (FatFreeCRM::Setting[:admin_tabs] && FatFreeCRM::Setting[:admin_tabs].dup)
      end
    end
  end
end
