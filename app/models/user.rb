class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum :user_role, { admin: 0, moderator: 1, member: 2 }
  has_many :messages
  has_many :chat_memberships
  has_many :chat_rooms, through: :chat_memberships
end
