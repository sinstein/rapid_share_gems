class Attachment < ActiveRecord::Base
  belongs_to :user
  before_save :process_file
  mount_uploader :launcher, LauncherUploader


  def process_file
    self.alias = self.launcher.filename
    self.name = Time.now.to_i.to_s + self.alias
    self.format = self.launcher.content_type

    whitelist = ["pdf","png","jpg","jpeg","rb","txt","azw"]
    if(self.name.nil?)
      errors.add(:file, " has no name")
    else
      ext = self.name.split('.')[-1]
      if !whitelist.include? ext
        errors.add(:file , " format not supported!")
      end
    end
  end

end
