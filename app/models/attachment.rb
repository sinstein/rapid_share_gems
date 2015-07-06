class Attachment < ActiveRecord::Base
  belongs_to :user
  before_save :process_file
  before_destroy :remove_the_launcher
  mount_uploader :launcher, LauncherUploader


  def process_file
    #debugger
    self.alias = self.launcher.filename
    self.name = self.launcher.file.original_filename
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

  def remove_the_launcher
      self.remove_launcher
  end

end
