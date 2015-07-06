class AttachmentsController < ApplicationController
  before_action :authenticate_user!, :route_user, except: :download

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
    if(@attachment.save!)
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
    if(Attachment.exists?(id: params[:id]))
      @attachment = @user.attachments.find(params[:id])
      #debugger
      send_file @attachment.launcher.current_path
    else
      redirect_to user_attachments_path, alert: "File does not exist."
    end
  end

  def destroy
    @user = User.find(current_user.id) or not_found
    if(Attachment.exists?(id: params[:id]))
      @attachment = @user.attachments.find(params[:id])
      name = @attachment.name
      @attachment.destroy!
      redirect_to user_attachments_path, alert:  "The file #{name} has been deleted."
    else
      redirect_to user_attachments_path, alert: "The file does not exist!"
    end
  end

end
