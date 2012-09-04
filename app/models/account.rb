# encoding: UTF-8
require 'digest/sha1'

class Account < ActiveRecord::Base
  belongs_to :person
  accepts_nested_attributes_for :person

  scope :enabled, :conditions =>["name NOT LIKE '[X] %%'"]
  scope :disabled, :conditions =>["name LIKE '[X] %%'"]

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :daum_account, :if => Proc.new{ daum_account && daum_account.empty? == false }
  validates_uniqueness_of :nate_account, :if => Proc.new{ nate_account && nate_account.empty? == false }
  # validates_uniqueness_of :notify_email, :if => Proc.new{ notify_email && notify_email.empty? == false }
  validates_uniqueness_of :google_account, :if => Proc.new{ google_account && google_account.empty? == false }

  validates_confirmation_of :password, :if => Proc.new{|account| account.provider.blank?}
  validate :password_non_blank, :if => Proc.new{|account| account.provider.blank?}

  attr_accessor :password_confirmation

  before_create :create_person_and_add_current_comapny

  def create_person_and_add_current_comapny
    myself = create_person
    myself.companies << Company.current_company
  end

  include Historiable
  include Attachmentable

  # def person
  #   myself = Person.find_by_id(person_id)
  #   unless myself
  #     myself = create_person!
  #     self.update_column(:person_id, myself.id)
  #   end
  #   myself
  # end

  # def enrollment
  #   Enrollment.find_by_person_id(person.id) || person.create_enrollment!(company_id: Company.current_company.id)
  # end

  def history_except
    [:name, :hashed_password, :salt]
  end

  def self.find_by_omniauth(auth)
    key = "#{auth["provider"]}_account".to_sym
    accounts = where(key => auth['info']['email'])
    account = if not accounts.empty?
      accounts.first
    else
      nil
    end
    account
  end

  def self.create_from_omniauth(auth)
    create do |account|
      account.provider = auth["provider"]
      account.uid = auth["uid"]
      account.send(auth["provider"] + "_account=", auth["info"]["email"])
      account.name = auth["info"]["nickname"] || auth["info"]["name"]
      account.notify_email = auth["info"]["email"]
    end
  end

  def fullname
    person.employee.nil? ? name : person.employee.fullname
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Account.encrypted_password(self.password, self.salt)
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
    account = self.find_by_name(name)
    if account
      expected_password = encrypted_password(password, account.salt)
      if account.hashed_password != expected_password
        account = nil
      end
    end
    account
  end

  def self.search(query)
    query = "%#{query}%"
    where('accounts.name like ?', query)
  end

  def self.enabled
    where("accounts.name NOT LIKE '[X] %'")
  end

  def as_json(options={})
    super(options.merge(:only => [:name, :google_account, :boxcar_account, :notify_email, :api_key]))
  end

  def create_api_key!(name, password)
    unless api_key
      self.api_key = Digest::SHA1.hexdigest(name + "--api--" + password)
      save!
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
    not (employee and employee.payments.empty?)
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
      transporter.get_users

      doc = Nokogiri.XML(transporter.response.body, nil, 'UTF-8')
      doc.remove_namespaces!

      doc.xpath('//entry/title').map {|node| {name: node.content}}
    end

    def google_transporter
      current_company = Company.current_company

      transporter = GoogleApps::Transport.new current_company.google_apps_domain
      transporter.authenticate current_company.google_apps_accountname, current_company.google_apps_password
      transporter
    end
  end

  def google_transporter
    self.class.google_transporter
  end

  def create_google_app_account
    return false unless person.employee

    current_company = Company.current_company
    transporter = google_transporter

    # Creating a Account
    user = GoogleApps::Atom::User.new
    user.set login: name, password: current_company.default_password, first_name: person.employee.firstname, last_name: person.employee.lastname
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

  class RedmineAccount < ActiveResource::Base
  end

  def get_remine_account
    current_company = Company.current_company

    RedmineAccount.element_name = "user"
    RedmineAccount.site = current_company.redmine_domain
    RedmineAccount.user = current_company.redmine_accountname
    RedmineAccount.password = current_company.redmine_password
    RedmineAccount
  end

  def new_redmine_account
    current_company = Company.current_company
    redmine_account = get_remine_account

    redmine_account.new(
      login: self.name,
      password: current_company.default_password,
      firstname: (person.employee.firstname rescue nil),
      lastname: (person.employee.lastname rescue nil),
      mail: notify_email
    )
  end

  def create_redmine_account
    current_company = Company.current_company
    redmine_account = get_remine_account

    raise ArgumentError, I18n.t('models.account.no_name') if person.employee and person.employee.firstname.blank?
    raise ArgumentError, I18n.t('models.account.no_name') if person.employee and person.employee.lastname.blank?
    raise ArgumentError, I18n.t('models.account.no_email') if notify_email.blank?

    redmine = redmine_account.new(
      login: self.name,
      password: current_company.default_password,
      firstname: (person.employee.firstname rescue nil),
      lastname: (person.employee.lastname rescue nil),
      mail: notify_email
    )

    unless redmine.save
      raise ArgumentError, I18n.t('models.account.already_exist_email')
    end

    self.redmine_account = redmine.login
    save!
  end

  def remove_redmine_account
    redmine_account = get_remine_account
    account = redmine_account.all.find {|account| account.login == self.name}
    account.destroy

    self.redmine_account = nil
    save
  end

  def needs_apply?
    not person.employee
  end

  def joined?
    person.joined?
  end

  def not_joined?
    person.not_joined?
  end

private
  def password_non_blank
    if hashed_password.blank?
      errors.add(:password, I18n.t('activerecord.errors.models.account.attributes.password.missing'))
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