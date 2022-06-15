class Message < ApplicationRecord
  validates :content, length: { minimum: 1, maximum: 50 }
  belongs_to :customer
  belongs_to :room
end
