class IsParanoidToPaperTrail < ActiveRecord::Migration
  def up
    [FatFreeCRM::Account, FatFreeCRM::Campaign, FatFreeCRM::Contact, FatFreeCRM::Lead, FatFreeCRM::Opportunity, FatFreeCRM::Task].each do |klass|
      klass.where('deleted_at IS NOT NULL').each(&:destroy)
    end
  end

  def down
  end
end
