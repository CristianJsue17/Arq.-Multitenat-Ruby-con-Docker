class OrderDetail < ApplicationRecord
  belongs_to :tenant
  belongs_to :order
  belongs_to :product

  scope :for_current_tenant, -> { where(tenant: Tenant.current) }

end
