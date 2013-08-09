class Phone < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :contact

  attr_accessible :description, :number

  validates :number, presence: true
end
