class User < ApplicationRecord
  belongs_to :tenant
  has_secure_password
  validates :username, uniqueness: { scope: :tenant_id, message: "ya existe para este tenant" }

  scope :for_current_tenant, -> { where(tenant: Tenant.current) }

end
