class Product < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :account
  has_many :deal_items
  validates :description, :price_cents, presence: true

  attr_accessible :description, :price_cents

  def to_json(args = {})
    super({methods: ['price_localized']}.merge(args))
  end

  def price_localized
    "R$ #{Money.new(price_cents, "BRL")}"
  end

end
