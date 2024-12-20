class Product < ApplicationRecord
    belongs_to :tenant
    has_one_attached :image
    has_many :cart_items  #para carrito

    scope :for_current_tenant, -> { where(tenant: Tenant.current) }

end
