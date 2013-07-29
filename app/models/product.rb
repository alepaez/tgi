class Product < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :account
  validates :description, :status, presence: true

  attr_accessible :description, :status, :price_cents

  acts_as_status :status, %w[available unavailable]
end
