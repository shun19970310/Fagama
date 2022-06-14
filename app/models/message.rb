class Message < ApplicationRecord
  validates :content, presence: true
  belongs_to :customer
  belongs_to :room
end
