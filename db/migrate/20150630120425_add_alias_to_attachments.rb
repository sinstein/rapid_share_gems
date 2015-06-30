class AddAliasToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :alias, :string
  end
end
