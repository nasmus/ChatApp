class AddRoleToChatMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :chat_memberships, :chat_role, :string, default: "member"
  end
end
