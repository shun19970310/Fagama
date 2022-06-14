class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy

  has_many :group_users, dependent: :destroy

  has_many :groups, through: :group_users, dependent: :destroy

  has_many :relationships, foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :follower

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :following

  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  def alive_followers
    followers.where(is_deleted: false)
  end

  def alive_followings
    followings.where(is_deleted: false)
  end

  def is_followed_by?(customer)
    reverse_of_relationships.find_by(following_id: customer.id).present?
  end

  def active_for_authentication?
    super && (is_deleted == false)
  end

  def self.guest
    find_or_create_by!(name: "guestuser" ,email: "guest@example") do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "guestuser"
    end
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  validates :email, presence: true

  attachment :image, destroy: false

end
