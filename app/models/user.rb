require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :attachment
  has_many :document_owners, :order => 'created_at DESC'
  has_many :documents, :through => :document_owners, :source => :document
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permission
  has_and_belongs_to_many :projects
  has_one :hrinfo

  has_many :payments
  has_many :commutes
  has_many :vacations
  has_many :change_histories

  scope :nohrinfo, :conditions =>['id not in (select user_id from hrinfos)']

  validates_presence_of :name
  validates_uniqueness_of :name, :gmail_account

  attr_accessor :password_confirmation
  validates_confirmation_of :password, :if => Proc.new{|user| user.provider.blank? and user.uid.blank?}
  validate :password_non_blank, :if => Proc.new{|user| user.provider.blank? and user.uid.blank?}

  cattr_accessor :current_user

  include Historiable

  def self.find_or_create_with_omniauth!(auth)
#    users = where(:provider => auth['provider'], :uid => auth['uid'])
    users = where(:gmail_account => auth['info']['email'])
    user = if not users.empty?
      users.first
    else
      nil
#      self.new(:provider => auth['provider'], :uid => auth['uid'])
    end

#    user.name = auth['info']['name']
#    user.name = auth['info']['email'].split('@').first

#    user.save(:validate => false)
#    user.save!
    user
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def disable
    self.password = rand.to_s
    self.name = '[X] '+self.name
    self.save
  end

  def disabled?
    if name.index("[X] ")
      true
    else
      false
    end
  end

  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def ingroup? (gname)
    g = Group.find_by_name(gname)
    unless g.nil?
      g.users.include? self
    else
      false
    end
  end


  def self.search(query)
    query = "%#{query || ""}%"
    where('name like ?', query)
  end

  def self.enabled
    where("name NOT LIKE '[X] %'")
  end

  def as_json(options={})
    super(options.merge(:only => [:name, :gmail_account, :boxcar_account, :notify_email, :api_key]))
  end

  def create_api_key(name, password)
    unless api_key
      self.api_key = Digest::SHA1.hexdigest(name + "--api--" + password)
      save
    end
  end

  def commute
    collection = commutes.where(leave: nil)
    if collection.empty?
      commute = collection.create
      commute.go!
      commute
    else
      commute = collection.last
      commute.leave!
      commute
    end
  end

private
  def password_non_blank
    if hashed_password.blank?
      errors.add(:password, I18n.t('users.error.missing_password'))
    end
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end