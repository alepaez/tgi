class Contact < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :account
  has_many :phones

  validates :name, presence: true

  attr_accessible :name, :email

end
