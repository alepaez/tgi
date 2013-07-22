class Phone < ActiveRecord::Base
  include ActiveUUID::UUID

  belongs_to :contact

  validates :number, presence: true
end
