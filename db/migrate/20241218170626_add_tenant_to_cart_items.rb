class AddTenantToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :cart_items, :tenant, null: false, foreign_key: true
  end
end
