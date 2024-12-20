class Order < ApplicationRecord
  belongs_to :tenant
  belongs_to :user

  scope :for_current_tenant, -> { where(tenant: Tenant.current) }

end
