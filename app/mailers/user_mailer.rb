class UserMailer < ActionMailer::Base
  default :from => "ibesthelp@uidaho.edu"
  
  def invitation_to_share(shared_folder)
    @shared_folder = shared_folder
    mail( :to => @shared_folder.shared_email, 
          :subject => "#{@shared_folder.user.name} wants to share '#{@shared_folder.folder.name}' folder with you" )
  end
  
  def share_notice_to_admin(shared_folder)
    @shared_folder = shared_folder
    mail( :to => "ibesthelp@uidaho.edu",
          :subject => "[Filebox] Share request generated." )
  end
  
  def invitation_to_join(invitation)
    @invitation = invitation
    mail( :to => @invitation.invited_user_email,
          :subject => "#{@invitation.user.name} has invited you to the IBEST Filebox" )
  end
  
  def invitation_notice_to_admin(invitation)
    @invitation = invitation
    mail( :to => "ibesthelp@uidaho.edu",
          :subject => "[Filebox] Invitation sent." )
  end
  
end
