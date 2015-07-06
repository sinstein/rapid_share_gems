class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from Exception, :with => :record_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from CarrierWave::IntegrityError, with: :invalid_file

  def record_not_found
    flash[:error] = "Oops! We cannot find what you are looking for!"
    redirect_to new_user_session_path
    return
  end

  def invalid_file
    redirect_to new_user_attachment_path, alert: "File format not supported"
  end

  def route_user
    if !current_user.nil?
      if !params.empty? && params.key?(:user_id) && current_user.id.to_s != params[:user_id]
        redirect_to user_attachments_path(current_user.id), alert: "Unauthourized!!"
      end
    end
  end

  protect_from_forgery with: :exception
  def after_sign_in_path_for(user)
    user_attachments_path(user)
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end

  def validate_file_size(file)
    one_mb = 1048567
    if file.size > 2*one_mb
      redirect_to user_attachments_path, alert: "Too large. Should be < 2MB"
      return false
    end
    true
  end
end
