class SessionController < ApplicationController
  def create
    redirect_to user_attachments_path(@user.id)
  end

  def delete
    redirect_to user_session_path
  end

  def destroy
    redirect_to user_session_path
  end
end
