class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.id == @attachment.attachable.user_id
      @attachment.destroy
    end
  end
end
