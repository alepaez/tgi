class Address < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :contact

  attr_accessible :description, :country, :state, :city, :address, :number, :complement

  validates :country, :state, :address, :number, presence: true

end
