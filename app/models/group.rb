class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :customers, through: :group_users, dependent: :destroy

  validates :name, presence: true
  validates :introduction, presence: true, length: {maximum: 60}
end
