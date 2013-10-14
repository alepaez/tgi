class DealItem < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :deal
  belongs_to :product

  validates :quantity, presence: true

  attr_accessible :quantity, :product_id

  def product_ref
    product.description if product
  end

  def total_cents
    product.price_cents*quantity
  end

  def total_localized
    "R$ #{Money.new(total_cents, "BRL")}"
  end

  def product_price_localized
    "R$ #{Money.new(product.price_cents, "BRL")}"
  end
  
end
