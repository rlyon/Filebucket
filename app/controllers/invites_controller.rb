class InvitesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @invites = current_user.invites
  end
  
  def new
    @invite = current_user.invites.new
  end
  
  def create
    @invite = current_user.invites.create(params[:invite])
    @invite.user_id = current_user.id
    if @invite.save
      redirect_to invites_path, :notice => "The invitation has been sent"
    else
      render "new"
    end
  end
end
