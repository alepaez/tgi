class DealItem < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :deal
  belongs_to :product

  validates :quantity, presence: true

  attr_accessible :quantity, :product_id
  
end
