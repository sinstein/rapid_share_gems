class AddLauncherToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :launcher, :string
  end
end
