class AddTenantToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :tenant, null: false, foreign_key: true
  end
end
