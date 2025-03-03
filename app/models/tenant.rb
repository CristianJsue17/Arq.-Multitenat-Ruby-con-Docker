class Tenant < ApplicationRecord
    has_many :products, dependent: :destroy
    has_many :users, dependent: :destroy
    has_many :carts, dependent: :destroy
    has_many :orders, dependent: :destroy
    has_many :cart_items, through: :carts, source: :cart_items, dependent: :destroy
    has_many :order_details, through: :orders, source: :order_details, dependent: :destroy
  
    def self.current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  
    def self.current
      Thread.current[:current_tenant]
    end
  end
  