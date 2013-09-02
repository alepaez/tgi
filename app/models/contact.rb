class Contact < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :account
  has_many :phones
  has_many :addresses
  has_many :deals

  validates :name, presence: true

  attr_accessible :name, :email, :phones_attributes, :phones, :addresses, :addresses_attributes

  accepts_nested_attributes_for :phones, :addresses, allow_destroy: true

  def to_json(args = {})
    super(args.merge(include: ['phones', 'addresses']))
  end
end
