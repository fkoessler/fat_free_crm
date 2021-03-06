class CreateFatFreeCRMAddresses < ActiveRecord::Migration
  def self.up
    create_table :fat_free_crm_addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city,    limit: 64
      t.string :state,   limit: 64
      t.string :zipcode, limit: 16
      t.string :country, limit: 64
      t.string :full_address
      t.string :address_type, limit: 16

      t.references :addressable, polymorphic: true

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :fat_free_crm_addresses, [:addressable_id, :addressable_type], name: 'index_ffcrm_addresses_on_addressable_id_and_addressable_type'

    # Migrate data from assets to Address table into full_address blob
    FatFreeCRM::Contact.all.each do |asset|
      FatFreeCRM::Address.create(street1: asset.address, full_address: asset.address, address_type: "Business", addressable: asset)
    end

    FatFreeCRM::Account.all.each do |asset|
      FatFreeCRM::Address.create(street1: asset.billing_address, full_address: asset.billing_address, address_type: "Billing", addressable: asset)
      FatFreeCRM::Address.create(street1: asset.shipping_address, full_address: asset.shipping_address, address_type: "Shipping", addressable: asset)
    end

    FatFreeCRM::Lead.all.each do |asset|
      FatFreeCRM::Address.create(street1: asset.address, full_address: asset.address, address_type: "Business", addressable: asset)
    end

    # Remove addresses columns from assets allready migrated
    remove_column(:fat_free_crm_contacts, :address)
    remove_column(:fat_free_crm_accounts, :billing_address)
    remove_column(:fat_free_crm_accounts, :shipping_address)
    remove_column(:fat_free_crm_leads,    :address)
  end

  def self.down
    drop_table :fat_free_crm_addresses
    add_column(:fat_free_crm_contacts, :address, :string)
    add_column(:fat_free_crm_accounts, :billing_address, :string)
    add_column(:fat_free_crm_accounts, :shipping_address, :string)
    add_column(:fat_free_crm_leads,    :address, :string)
  end
end
