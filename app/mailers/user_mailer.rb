class UserMailer < ActionMailer::Base
  default :from => "ibesthelp@uidaho.edu"
  
  def invitation_to_share(shared_folder)
    @shared_folder = shared_folder #setting up an instance variable to be used in the email template
    mail( :to => @shared_folder.shared_email, 
          :subject => "#{@shared_folder.user.name} wants to share '#{@shared_folder.folder.name}' folder with you" )
  end
  
  def invitation_to_join(invitation)
    @invitation = invitation
    mail( :to => @invitation.invited_user_email,
          :bcc => "rlyon@uidaho.edu",
          :subject => "#{@invitation.user.name} has invited you to the IBEST Filebox" )
  end
  
end
