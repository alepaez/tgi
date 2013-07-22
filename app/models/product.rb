class Product < ActiveRecord::Base
  belongs_to :account
  validates :description, :status, presence: true
end
