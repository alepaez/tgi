class Contact < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :account
  has_many :phones

  validates :name, presence: true

  attr_accessible :name, :email, :phones_attributes, :phones

  accepts_nested_attributes_for :phones, allow_destroy: true

  def to_json(args = {})
    super(args.merge(include: 'phones'))
  end
end
