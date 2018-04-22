class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.text :body
      t.string :subject
      t.boolean :is_draft
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :emails, [:user_id, :created_at]
  end
end
