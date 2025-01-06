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

  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :rooms, through: :user_rooms

  has_many :read_counts, dependent: :destroy

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

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
end
