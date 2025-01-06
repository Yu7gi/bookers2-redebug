class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image

  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  has_many :followings, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :relation_followings, through: :followings, source: :followed
  has_many :relation_followers, through: :followers, source: :follower

  def follow(user)
    followings.create(followed_id: user.id)
  end

  def unfollow(user)
    followings.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    relation_followings.include?(user)
  end
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
