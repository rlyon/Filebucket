class User < ActiveRecord::Base
	has_many :assets
	has_many :folders
	has_many :shared_folders, :dependent => :destroy
	has_many :being_shared_folders, :class_name => "SharedFolder", :foreign_key => "shared_user_id", :dependent => :destroy
	has_many :shared_folders_by_others, :through => :being_shared_folders, :source => :folder
	has_many :public_folders, :dependent => :destroy
	
	has_many :invites, :dependent => :destroy
	has_one :sponser, :through => :invites 
	
	
	# Include default devise modules. Others available are:
	# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable
         

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me
	attr_accessible :name, :username

	validates :email, :presence => true, :uniqueness => true
	validates :username, :presence => true, :uniqueness => true
	validates_format_of :username, :with => /[a-z]+/,
	 :message => "can only contain lower case characters."
	#validates_format_of :password, :with => /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*[^\da-zA-Z]).{8,128}$/,
	# :message => "must contain at least 1 upper case character and one digit."
	 
  after_create :check_and_assign_shared_ids_to_shared_folders
  after_create :activate_if_invited

  def check_and_assign_shared_ids_to_shared_folders
    shared_folders_with_same_email = SharedFolder.find_all_by_shared_email(self.email)
    if ! shared_folders_with_same_email.empty?
      shared_folders_with_same_email.each do |shared_folder|
        shared_folder.shared_user_id = self.id
        shared_folder.save
      end
      # if the account has shared folders they were invited, so they
      # don't need administrative activation.
      logger.info "ACTIVATING ACCOUNT: #{email} has shared folders"
      self.account_active = 1
      self.save
    end    
  end
  
  def activate_if_invited
    invited_user = Invite.find_by_invited_user_email(self.email)
    if ! invited_user.nil?
      invited_user.update_attribute(:invited_user_id, self.id)
      self.account_active = 1
      self.save
    end
  end
  
  def has_share_access?(folder)
    return true if self.folders.include?(folder)
    return true if self.shared_folders_by_others.include?(folder)
    return_value = false
  
    folder.ancestors.each do |ancestor_folder|
      return_value = self.being_shared_folders.include?(ancestor_folder)
      if return_value #if it's true
        return true
      end
    end
  
    return false
  end
  
  def active_for_authentication?
    # logger.debug self.to_yaml
    super && account_active?
  end
end
