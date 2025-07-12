class ChatMembership < ApplicationRecord
  enum :chat_role, { admin: 0, moderator: 1, member: 2 }
  belongs_to :user
  belongs_to :chat_room
end
