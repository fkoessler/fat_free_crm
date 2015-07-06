class AddFieldGroupsKlassName < ActiveRecord::Migration
  def up
    add_column :fat_free_crm_field_groups, :klass_name, :string, limit: 32

    # Add a default field group for each model
    %w(FatFreeCRM::Account FatFreeCRM::Campaign FatFreeCRM::Contact FatFreeCRM::Lead FatFreeCRM::Opportunity).each do |entity|
      klass = entity.classify.constantize
      field_group = FatFreeCRM::FieldGroup.new
      field_group.label, field_group.klass_name = 'Custom Fields', klass.name
      field_group.save!
      FatFreeCRM::Field.where(field_group_id: nil, klass_name: klass.name).update_all(field_group_id: field_group.id)
    end
    FatFreeCRM::FieldGroup.where(klass_name: nil).update_all('klass_name = (SELECT MAX(klass_name) FROM fat_free_crm_fields WHERE field_group_id = fat_free_crm_field_groups.id)')

    remove_column :fat_free_crm_fields, :klass_name
    FatFreeCRM::Field.reset_column_information
  end

  def down
    add_column :fat_free_crm_fields, :klass_name, :string, limit: 32
    connection.execute 'UPDATE fat_free_crm_fields SET klass_name = (SELECT MAX(klass_name) FROM fat_free_crm_field_groups WHERE fat_free_crm_field_groups.id = field_group_id)'
    remove_column :fat_free_crm_field_groups, :klass_name
  end
end
