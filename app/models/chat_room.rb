class ChatRoom < ApplicationRecord
    enum :chat_type, {private_chat: 0, group_chat: 1}
    has_many :messages
    has_many :chat_memberships
    has_many :users, through: :chat_memberships
end
