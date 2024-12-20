class Cart < ApplicationRecord
  belongs_to :tenant
  has_many :cart_items, dependent: :destroy

  def total
    cart_items.to_a.sum { |cart_item| cart_item.total }
  end

  def count
    cart_items.to_a.sum { |cart_item| cart_item.quantity }
  end

  scope :for_current_tenant, -> { where(tenant: Tenant.current) }

end
