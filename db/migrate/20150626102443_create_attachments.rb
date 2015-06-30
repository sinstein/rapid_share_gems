class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
        t.string :name
        t.string :format
        t.integer :user_id
        t.timestamps null: false
      t.timestamps null: false
    end
  end
end
