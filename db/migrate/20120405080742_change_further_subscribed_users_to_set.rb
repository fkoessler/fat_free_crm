class ChangeFurtherSubscribedUsersToSet < ActiveRecord::Migration
  def up
    # Change the other tables that were missing from the previous migration
    %w(fat_free_crm_campaigns fat_free_crm_opportunities fat_free_crm_leads fat_free_crm_tasks fat_free_crm_accounts).each do |table|
      entities = connection.select_all %(
        SELECT id, subscribed_users
        FROM #{table}
        WHERE subscribed_users IS NOT NULL
            )

      puts "#{table}: Converting #{entities.size} subscribed_users arrays into sets..." unless entities.empty?

      # Run as one atomic action.
      ActiveRecord::Base.transaction do
        entities.each do |entity|
          subscribed_users_set = Set.new(YAML.load(entity["subscribed_users"]))

          connection.execute %(
            UPDATE #{table}
            SET subscribed_users = '#{subscribed_users_set.to_yaml}'
            WHERE id = #{entity['id']}
                    )
        end
      end
    end
  end
end
