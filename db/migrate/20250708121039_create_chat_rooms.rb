class CreateChatRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.integer :chat_type

      t.timestamps
    end
  end
end
