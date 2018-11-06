class User < UserApiResource
  include RoleModel

  belongs_to :institution

  delegate :first_name, :last_name, :cellphone, to: :profile

  # The order of this is important, don't change it
  # append new roles at the end
  #
  # Rationale about the actual roles:
  # god_admin -> Limitless abilities
  # logistics_admin -> Ability to do everything in Logistics
  # marketplace_admin -> Ability to do everything in marketplace
  # logistics_manager -> Ability to do every non-destructive action in Logistics
  # marketplace_manager -> Ability to do every non-destructive action in Marketplace
  # shop_admin -> Ability to do everything in the scope of their own shop
  # shop_manager -> Ability to do every non-destructive action in the scope of their own shop
  # buyer -> Ability to use the mobile app to make purchase orders
  ROLES = %i[
    god_admin
    logistics_admin
    marketplace_admin
    logistics_manager
    marketplace_manager
    shop_admin
    shop_manager
    buyer
  ].freeze
  private_constant :ROLES

  roles *ROLES
end
