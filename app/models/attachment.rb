class Attachment < ActiveRecord::Base
  belongs_to :user
  mount_uploader :launcher, LauncherUploader
  validate :file_format
  

  def file_format
    whitelist = ["pdf","png","jpg","jpeg","rb","txt","azw",""]
    ext = self.name.split('.')[-1]
    if !whitelist.include? ext
      errors.add(:file , " format not supported!")
    end
  end
end