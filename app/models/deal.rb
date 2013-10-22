#encoding: utf-8
class Deal < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :contact
  has_many :items, class_name: "DealItem", dependent: :destroy

  accepts_nested_attributes_for :items

  attr_accessible :items_attributes, :product_id, :status

  acts_as_status :status, %w[open lost won]

  validate :validate_changes

  def to_json(args = {})
    super(args.merge(
      methods: ['contact_ref', 'total_localized'],
      include: { items: {
        methods: [ 'product_ref', 'product_price_localized', 'total_localized' ]
      }
    }))
  end

  def contact_ref
    contact.name || contact.email if contact
  end

  def total_cents
    items.sum(&:total_cents)
  end

  def total_localized
    "R$ #{Money.new(total_cents, "BRL")}"
  end

  private

  def changed_from_won_or_lost
    changed_attributes["status"] == "won" || changed_attributes["status"] == "lost"
  end

  def validate_changes
    errors.add(:base, "Essa negociação já foi finalizada") if changed_from_won_or_lost
  end

end
