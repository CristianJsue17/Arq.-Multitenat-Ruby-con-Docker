class AddTenantToOrderDetails < ActiveRecord::Migration[7.0]
  def change
    add_reference :order_details, :tenant, null: false, foreign_key: true
  end
end
