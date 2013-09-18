class Deal < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :contact
  has_many :items, class_name: "DealItem", dependent: :destroy

  accepts_nested_attributes_for :items

  attr_accessible :items_attributes, :product_id

  def to_json(args = {})
    super(args.merge(include: ['items'], methods: ['contact_ref']))
  end

  def contact_ref
    contact.name || contact.email if contact
  end
end
