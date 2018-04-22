class CreateSenderReceivers < ActiveRecord::Migration[5.1]
  def change
    create_table :sender_receivers do |t|
      t.integer :sender_user_id
      t.integer :receiver_user_id
      t.boolean :is_opened
      t.boolean :is_deleted_by_sender
      t.boolean :is_deleted_by_receiver
      t.references :email, foreign_key: true

      t.timestamps
    end
  end
end
