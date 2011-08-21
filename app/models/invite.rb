# Validator to check via email if a user is already a member.
class NotMemberValidator < ActiveModel::EachValidator
  # Perform validation
  def validate_each(record, attribute, value)
    user = User.find_by_email(value)
    record.errors[attribute] << 'already has an account.' unless user.nil?
  end
end

# Validator to check via email if an invitaion is already present
class NotInvitedValidator < ActiveModel::EachValidator
  # Perform validation
  def validate_each(record, attribute, value)
    invite = Invite.find_by_invited_user_email(value)
    record.errors[attribute] << 'has already been invited to join.' unless invite.nil?
  end
end

# Invitations.  Allows the invited user to bypass the normal admin activation process
class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited_user, :class_name => "User"
  
  attr_accessible :user_id, :invited_user_email, :message
  
  validates :invited_user_email, :presence => true, :not_invited => true, :not_member => true
  
  # Check the status of an invited person
  def status
    self.invited_user_id.nil? ? "pending" : "member"
  end
end
