class AttachmentsController < ApplicationController
  before_action :route_user, except: :download

  def new
  end

  def index
    @attachments = Attachment.where(:user_id => current_user.id)
    if(@attachments.empty?)
      redirect_to new_user_attachment_path
    end
  end

  def create
    uploader = LauncherUploader.new
    @user = User.find(current_user.id)
    @attachment = Attachment.new(params[:attachment => {:file => [ :original_filename ]}])
    @attachment.name = params[:attachment][:file].original_filename
    @attachment.format = params[:attachment][:file].content_type
    @attachment.user_id = @user.id
    @attachment.alias = Time.now.to_i.to_s + @attachment.name
    #if !validate_file_size(params[:attachment][:file])
    if !uploader.store!(params[:attachment][:file])
      render "new"
    else
      @attachment.save
      redirect_to user_attachments_path, notice: "The file #{@attachment.name} was uploaded"
    end
  end

  def show
    @user = User.find(current_user.id)
    @attachment = user.attachments.find(@user.id)
  end

  def download
    @user = User.find(params[:user_id])
    @attachment = @user.attachments.find(params[:id])
    send_file "#{Rails.root}/public/data/#{@attachment.alias}"
  end

  def destroy
    @user = User.find(current_user.id) or not_found
    @attachment = @user.attachments.find(params[:id])
    @attachment.destroy
    name = @attachment.name
    File.delete(Rails.root.join('public/data', @attachment.alias))
    redirect_to user_attachments_path, alert:  "The file #{name} has been deleted."
  end

end
