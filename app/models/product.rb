class Product < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :account
  validates :description, :price_cents, presence: true

  attr_accessible :description, :price_cents

end
