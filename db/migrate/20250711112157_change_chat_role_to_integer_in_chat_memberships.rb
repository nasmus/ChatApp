class ChangeChatRoleToIntegerInChatMemberships < ActiveRecord::Migration[8.0]
  def change
     change_column :chat_memberships, :chat_role, :integer, default: 2
  end
end
