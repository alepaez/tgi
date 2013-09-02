class Deal < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :contact
  has_many :items, class_name: "DealItem"

  accepts_nested_attributes_for :items

  attr_accessible :items, :items_attributes, :product_id

  def to_json(args = {})
    super(args.merge(include: ['items']))
  end
end
