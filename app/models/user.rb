require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :attachment
  has_many :document_owners, :order => 'created_at DESC'
  has_many :documents, :through => :document_owners, :source => :document
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permission
  has_and_belongs_to_many :projects
  has_many :pay_schedules, :order => 'payday ASC'
  has_one :hrinfo
  has_many :annual_pay_schedules
  has_many :bonuses

  scope :nohrinfo, :conditions =>['id not in (select user_id from hrinfos)']

  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  validate :password_non_blank

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

private
  def password_non_blank
    errors.add(:password, I18n.t('users.error.missing_password')) if hashed_password.blank?
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.search(query)
    query = "%#{query || ""}%"
    where('name like ?', query)
  end
end