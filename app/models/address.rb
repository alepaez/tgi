class Address < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :contact

  validates :country, :state, :address, :number, presence: true

end
