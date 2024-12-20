class AddTenantToCarts < ActiveRecord::Migration[7.0]
  def change
    add_reference :carts, :tenant, null: false, foreign_key: true
  end
end
