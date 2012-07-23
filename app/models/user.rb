# encoding: UTF-8
require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :enrollment
  # has_many :attachment
  # has_many :document_owners, :order => 'created_at DESC'
  # has_many :documents, :through => :document_owners, :source => :document
  
  # has_and_belongs_to_many :groups
  # has_and_belongs_to_many :permission
  
  # has_many :project_infos, class_name: "ProjectAssignInfo"
  # has_many :projects, through: :project_infos

  has_one :hrinfo, dependent: :destroy
  accepts_nested_attributes_for :hrinfo, :allow_destroy => :true

  has_many :contacts, foreign_key: 'owner_id'

  # has_many :payments
  # has_many :commutes
  # has_many :vacations
  # has_many :change_histories
  # has_many :reporters, class_name: 'ReportPerson'

  # has_many :except_columns
  has_and_belongs_to_many :companies

  scope :nohrinfo, :conditions =>['id not in (select user_id from hrinfos)']
  scope :enabled, :conditions =>["name NOT LIKE '[X] %%'"]
  scope :disabled, :conditions =>["name LIKE '[X] %%'"]

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :daum_account, :if => Proc.new{ daum_account && daum_account.empty? == false }
  validates_uniqueness_of :nate_account, :if => Proc.new{ nate_account && nate_account.empty? == false }
  validates_uniqueness_of :notify_email, :if => Proc.new{ notify_email && notify_email.empty? == false }
  validates_uniqueness_of :google_account, :if => Proc.new{ google_account && google_account.empty? == false }
  attr_accessor :password_confirmation
  validates_confirmation_of :password, :if => Proc.new{|user| user.provider.blank?}
  validate :password_non_blank, :if => Proc.new{|user| user.provider.blank?}

  has_one :company, foreign_key: :apply_admin_id

  cattr_accessor :current_user

  include Historiable
  include Attachmentable

  def enrollment
    Enrollment.find_by_user_id(id) || create_enrollment!(company_id: Company.current_company.id)
  end

  def history_except
    [:name, :hashed_password, :salt]
  end

  def self.find_by_omniauth(auth)
    key = "#{auth["provider"]}_account".to_sym
    users = where(key => auth['info']['email'])
    user = if not users.empty?
      users.first
    else
      nil
    end
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.send(auth["provider"] + "_account=", auth["info"]["email"])
      user.name = auth["info"]["nickname"] || auth["info"]["name"]
      user.notify_email = auth["info"]["email"]
    end
  end

  def fullname
    hrinfo.nil? ? name : hrinfo.fullname
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

  def enabled?
    ! disabled?
  end

  def self.enabled
    where("name NOT LIKE '[X] %'").order("id ASC")
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
    hrinfo.ingroup?(gname)
  end

  def self.no_admins
    all - joins(:hrinfo => :groups).where('groups.name == ?', "admin")
  end

  def permission?(name)
    admin? or hrinfo.permission.exists?(name: name.to_s)
  end

  def admin?
    # self.ingroup? "admin"
    hrinfo.admin?
  end

  def self.search(query)
    query = "%#{query}%"
    where('users.name like ?', query)
  end

  def self.enabled
    where("users.name NOT LIKE '[X] %'")
  end

  def as_json(options={})
    super(options.merge(:only => [:name, :google_account, :boxcar_account, :notify_email, :api_key]))
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

  def has_payment_info
    not hrinfo.payments.empty?
  end

  class << self
    def check_disabled(check)
      if check == 'on'
        disabled
      else
        enabled
      end
    end

    def has_google_apps_account
      transporter = google_transporter
      transporter.get_user

      doc = Nokogiri.XML(transporter.response.body, nil, 'UTF-8')
      doc.remove_namespaces!

      doc.xpath('//entry/title').map {|node| {name: node.content}}
    end

    def google_transporter
      current_company = Company.current_company
      transporter = GoogleApps::Transport.new current_company.google_apps_domain
      transporter.authenticate current_company.google_apps_username, current_company.google_apps_password
      transporter
    end

    def prepare_apply(params)
      new.tap do |user|
        user.provider = params[:provider]
        user.send(params[:provider] + "_account=", params[:email])
        user.notify_email = params[:email]
        user.build_hrinfo.build_contact
      end
    end
  end

  # include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  def save_apply(report_url)
    tap do |user|
      user.hrinfo.prevent_create_report = true
      user.hrinfo.contact.firstname = user.hrinfo.firstname
      user.hrinfo.contact.lastname = user.hrinfo.lastname
      user.save!

      User.current_user = user
      user.hrinfo.create_initial_report
      user.hrinfo.report.save!
      user.hrinfo.create_initial_accessor

      admin = Company.current_company.apply_admin
      user.hrinfo.report!(admin, "", report_url)
    end
  rescue => e
    destroy
    raise e
  end

  def google_transporter
    self.class.google_transporter
  end

  def create_google_app_account
    return false unless hrinfo

    current_company = Company.current_company
    transporter = google_transporter

    # Creating a User
    user = GoogleApps::Atom::User.new
    user.new_user name, hrinfo.firstname, hrinfo.lastname, current_company.default_password, 2048
    transporter.new_user user

    doc = Nokogiri::XML(transporter.response.body)
    Rails.logger.info "#create_google_app_account - response = #{transporter.response.body}"

    error_code = doc.xpath('//AppsForYourDomainErrors/error').first['errorCode'] rescue 0
    if error_code == 0
      self.google_account = "#{name}@#{current_company.google_apps_domain}"
      save
    else
      false
    end
  end

  def remove_google_app_account
    transporter = google_transporter
    transporter.delete_user name

    Rails.logger.info "#remove_google_app_account - response = #{transporter.response.body}"

    doc = Nokogiri::XML(transporter.response.body)
    error_code = doc.xpath('//AppsForYourDomainErrors/error').first['errorCode'] rescue 0
    if error_code == 0
      self.google_account = nil
      save
    else
      false
    end
  end

  class RedmineUser < ActiveResource::Base
  end

  def get_remine_user
    current_company = Company.current_company

    RedmineUser.element_name = "user"
    RedmineUser.site = current_company.redmine_domain
    RedmineUser.user = current_company.redmine_username
    RedmineUser.password = current_company.redmine_password
    RedmineUser
  end

  def new_redmine_account
    current_company = Company.current_company
    redmine_user = get_remine_user

    redmine_user.new(
      login: self.name,
      password: current_company.default_password,
      firstname: (hrinfo.firstname rescue nil),
      lastname: (hrinfo.lastname rescue nil),
      mail: notify_email
    )
  end

  def create_redmine_account
    current_company = Company.current_company
    redmine_user = get_remine_user

    raise ArgumentError, I18n.t('models.user.no_name') if hrinfo and hrinfo.firstname.blank?
    raise ArgumentError, I18n.t('models.user.no_name') if hrinfo and hrinfo.lastname.blank?
    raise ArgumentError, I18n.t('models.user.no_email') if notify_email.blank?

    redmine = redmine_user.new(
      login: self.name,
      password: current_company.default_password,
      firstname: (hrinfo.firstname rescue nil),
      lastname: (hrinfo.lastname rescue nil),
      mail: notify_email
    )

    unless redmine.save
      raise ArgumentError, I18n.t('models.user.already_exist_email')
    end

    self.redmine_account = redmine.login
    save!
  end

  def remove_redmine_account
    redmine_user = get_remine_user
    user = redmine_user.all.find {|user| user.login == self.name}
    user.destroy

    self.redmine_account = nil
    save
  end

  def joined?
    companies.exists?
  end

  def not_joined?
    not joined?
  end

private
  def password_non_blank
    if hashed_password.blank?
      errors.add(:password, I18n.t('activerecord.errors.models.user.attributes.password.missing'))
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