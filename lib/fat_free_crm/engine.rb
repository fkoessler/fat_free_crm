# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCRM
  class Engine < ::Rails::Engine

    isolate_namespace FatFreeCRM

    config.autoload_paths += Dir[root.join("app/models/**/")] +
        Dir[root.join("app/controllers/fat_free_crm/entities")] +
        Dir[root.join("app/decorators/**/*_decorator*.rb")]

    config.active_record.observers = ['FatFreeCRM::EntityObserver', 'FatFreeCRM::LeadObserver',
                                      'FatFreeCRM::OpportunityObserver', 'FatFreeCRM::TaskObserver']

    initializer "model_core.factories", :after => "factory_girl.set_factory_paths" do
      FactoryGirl.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__) if defined?(FactoryGirl)
    end

    config.to_prepare do
      Dir.glob(Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

  end
end
