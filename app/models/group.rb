class Group < ApplicationRecord
  has_many :group_users
  has_many :customers, through: :group_users

  validates :name, presence: true
  validates :introduction, presence: true
end
