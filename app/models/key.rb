class Key < ActiveRecord::Base 
  belongs_to :user
  has_many :keyed_folders, :dependent => :destroy
  has_many :folders, :through => :keyed_folders
  
  validates :name, :presence => true
  validates :email, :presence => true
  validates :expires_at, :date => { :after => Time.now, :message => "must be after today" } 
  
  before_save :generate_auth
  
  private
  def generate_auth
    self.auth = SecureRandom.hex(32)
  end
end
