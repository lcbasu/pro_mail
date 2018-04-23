class AddSourceFieldToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :source_email_id, :integer, default: -1
  end
end
