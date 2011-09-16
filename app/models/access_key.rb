# Access keys attached to specific email addresses.  Generates authorization strings that
# can be used to authenticate to the filebucket and download zipped folders
class AccessKey < ActiveRecord::Base 
  belongs_to :user
  has_many :keyed_folders, :dependent => :destroy
  has_many :folders, :through => :keyed_folders, :readonly => false
  
  validates :name, :presence => true
  validates :email, :presence => true
  validates :expires_at, :date => { :after => Time.now, :message => "must be after today" } 
  
  before_save :generate_auth
  
  def self.authenticate(email,auth)
    @key ||= AccessKey.find(:first, :conditions => ["email = ? AND auth = ?", email, auth])
    if @key.expires_at < Time.now
      return nil
    else
      return @key
    end
    return nil
  end
  
  private
  # Generate the authorization key
  def generate_auth
    self.auth = SecureRandom.hex(32)
  end
end
