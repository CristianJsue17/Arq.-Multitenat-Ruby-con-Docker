class CartItem < ApplicationRecord
  belongs_to :tenant
  belongs_to :cart
  belongs_to :product
  validates :quantity, numericality: { greater_than: 0 }

  def total
    product.price * quantity
  end

  scope :for_current_tenant, -> { where(tenant: Tenant.current) }

end
