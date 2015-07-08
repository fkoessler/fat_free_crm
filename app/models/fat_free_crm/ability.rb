class FatFreeCRM::Ability < Ability

  def initialize(user)

    super

    # Engine's CanCan rules

    # handle signup
    if user.present?

      entities = [FatFreeCRM::Account, FatFreeCRM::Campaign, FatFreeCRM::Contact, FatFreeCRM::Lead, FatFreeCRM::Opportunity]

      # User
      can :manage, User, id: user.id # can do any action on themselves

      # Tasks
      can :create, FatFreeCRM::Task
      can :manage, FatFreeCRM::Task, user: user.id
      can :manage, FatFreeCRM::Task, assigned_to: user.id
      can :manage, FatFreeCRM::Task, completed_by: user.id

      # Entities
      can :manage, entities, access: 'Public'
      can :manage, entities + [FatFreeCRM::Task], user_id: user.id
      can :manage, entities + [FatFreeCRM::Task], assigned_to: user.id

      #
      # Due to an obscure bug (see https://github.com/ryanb/cancan/issues/213)
      # we must switch on user.admin? here to avoid the nil constraints which
      # activate the issue referred to above.
      #
      user.has_role? :administrator
        can :manage, :all
      else
        # Group or User permissions
        t = FatFreeCRM::Permission.arel_table
        scope = t[:user_id].eq(user.id)

        if (group_ids = user.group_ids).any?
          scope = scope.or(t[:group_id].eq_any(group_ids))
        end

        entities.each do |klass|
          if (asset_ids = FatFreeCRM::Permission.where(scope.and(t[:asset_type].eq(klass.name))).pluck(:asset_id)).any?
            can :manage, klass, id: asset_ids
          end
        end
      end

    end
  end
end
