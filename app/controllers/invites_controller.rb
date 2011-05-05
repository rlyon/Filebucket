class InvitesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @invites = current_user.invites
  end
  
  def new
    @invite = current_user.invites.new
  end
  
  def create
    @invite = current_user.invites.new(params[:invite])

    if @invite.save
      UserMailer.invitation_to_join(@invite).deliver
      redirect_to invites_path, :notice => "The invitation has been sent"
    else
      render "new"
    end
  end
end
