class AddDraftFieldToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :receivers_for_draft, :string
  end
end
