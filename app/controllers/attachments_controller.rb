class AttachmentsController < ApplicationController
  before_action :route_user, except: :download

  def new
    @attachment = Attachment.new
  end

  def index
    @attachments = Attachment.where(:user_id => current_user.id)
    if(@attachments.empty?)
      redirect_to new_user_attachment_path
    end
  end

  def create
    @attachment = Attachment.new
    @attachment.launcher = params[:attachment][:file]
    @attachment.user_id = current_user.id

    if @attachment.save!
      debugger
      redirect_to user_attachments_path, notice: "The file #{@attachment.name} was uploaded"
    else
      render "new"
    end
  end

  def show
    @user = User.find(current_user.id)
    @attachment = user.attachments.find(@user.id)
  end

  def download
    @user = User.find(params[:user_id])
    @attachment = @user.attachments.find(params[:id])
    send_file @attachment.launcher.url
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
